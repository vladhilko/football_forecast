# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sportsbook::PlaceWagers do
  it 'debits stakes, hides early results, and credits a winning payout once' do
    user = create(:user)
    session = create(:time_travel_session, user:)
    fixture = create(:time_travel_session_match, time_travel_session: session, position: 0,
                                                 final_home_score: 2, final_away_score: 0)

    wagers = described_class.call(
      user:, session:, placement_key: 'placement-1',
      selections: [{ fixture_id: fixture.uuid, selection: 'home', stake_minor: 10_000 }]
    )
    expect(user.wallet.reload.balance_minor).to eq(990_000)

    travel_to(Time.zone.local(2026, 8, 10, 12)) do
      Sportsbook::StartReveal.call(session:)
      early = Sportsbook::RevealSnapshot.call(session:, now: 20.seconds.from_now)
      expect(early[:fixtures].first).to eq(id: fixture.uuid, position: 0, revealed: false)

      Sportsbook::SettleSession.call(session:, now: 46.seconds.from_now)
      Sportsbook::SettleSession.call(session:, now: 47.seconds.from_now)
    end

    expect(wagers.first.reload).to have_attributes(status: 'won', payout_minor: 21_000)
    expect(user.wallet.reload.balance_minor).to eq(1_011_000)
    expect(user.wallet.wallet_entries.where(entry_type: 'payout_credit').count).to eq(1)
  end

  it 'returns the original wager without a second debit for a repeated idempotency key' do
    user = create(:user)
    session = create(:time_travel_session, user:)
    fixture = create(:time_travel_session_match, time_travel_session: session)
    request = {
      user:, session:, placement_key: 'same-confirmation',
      selections: [{ fixture_id: fixture.uuid, selection: 'home', stake_minor: 10_000 }]
    }

    first = described_class.call(**request)
    second = described_class.call(**request)

    expect(second.map(&:id)).to eq(first.map(&:id))
    expect(user.wallet.reload.balance_minor).to eq(990_000)
    expect(user.wallet.wallet_entries.where(entry_type: 'stake_debit').count).to eq(1)
  end

  it 'rolls back the complete bet slip when any selection is invalid' do
    user = create(:user)
    session = create(:time_travel_session, user:)
    fixture = create(:time_travel_session_match, time_travel_session: session)

    expect do
      described_class.call(
        user:, session:, placement_key: 'atomic-confirmation',
        selections: [
          { fixture_id: fixture.uuid, selection: 'home', stake_minor: 10_000 },
          { fixture_id: 'missing-fixture', selection: 'away', stake_minor: 10_000 }
        ]
      )
    end.to raise_error(Sportsbook::Error, 'One of the selected fixtures is not part of this round')

    expect(user.wallet.reload.balance_minor).to eq(1_000_000)
    expect(user.wagers).to be_empty
    expect(user.wallet.wallet_entries.where(entry_type: 'stake_debit')).to be_empty
  end

  it 'rounds a decimal-odds payout once using half-up rounding' do
    user = create(:user)
    session = create(:time_travel_session, user:)
    fixture = create(:time_travel_session_match, time_travel_session: session, home_odds: 1.005)

    wager = described_class.call(
      user:, session:, placement_key: 'rounding-confirmation',
      selections: [{ fixture_id: fixture.uuid, selection: 'home', stake_minor: 101 }]
    ).first

    expect(wager.potential_payout_minor).to eq(102)
  end

  it 'preserves real final scores while labeling synthetic replay events as simulated' do
    user = create(:user, preferred_reveal_mode: 'synthetic')
    session = create(:time_travel_session, user:, reveal_mode: 'synthetic')
    fixture = create(:time_travel_session_match, time_travel_session: session,
                                                 final_home_score: 2, final_away_score: 1)
    described_class.call(
      user:, session:, placement_key: 'synthetic-confirmation',
      selections: [{ fixture_id: fixture.uuid, selection: 'home', stake_minor: 100 }]
    )

    travel_to(Time.zone.local(2026, 8, 10, 12)) do
      Sportsbook::StartReveal.call(session:)
      early = Sportsbook::RevealSnapshot.call(session:, now: 20.seconds.from_now)
      final = Sportsbook::RevealSnapshot.call(session:, now: 46.seconds.from_now)

      expect(early).to include(reveal_mode: 'synthetic', status: 'revealing')
      expect(final[:fixtures].first).to include(home_score: 2, away_score: 1, result: 'home')
    end
  end
end
