# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wager do
  it 'does not allow confirmed wager terms to change' do
    wager = create(:wager)

    expect(wager.update(selection: 'away', stake_minor: 20_000)).to be(false)
    expect(wager.errors.full_messages).to include('confirmed wagers are immutable')
    expect(wager.reload).to have_attributes(selection: 'home', stake_minor: 10_000)
  end

  it 'allows settlement fields to change' do
    wager = create(:wager)

    expect(wager.update(status: 'won', payout_minor: 21_000, settled_at: Time.current)).to be(true)
  end

  it 'does not allow a historical fixture snapshot to change' do
    fixture = create(:time_travel_session_match)

    expect(fixture.update(final_home_score: 99)).to be(false)
    expect(fixture.errors.full_messages).to include('historical round snapshots are immutable')
    expect(fixture.reload.final_home_score).to eq(2)
  end
end
