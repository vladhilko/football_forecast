# frozen_string_literal: true

require 'rails_helper'

describe Betting::ResolveBet::EntryPoint do
  subject { described_class.new(bet).call }

  let(:match) { create(:match, home_team: 'Arsenal', away_team: 'Chelsea', score: '2:1') }
  let(:betting_odds) { create(:betting_odds, home_team_win: 2.45, match:) }

  context 'when the bet is winning' do
    let(:bet) { create(:bet, match:, team: 'Arsenal', bet_type: 'win') }

    it 'resolve bet with `win` result', :aggregate_failures do
      expect { subject }.to change { bet.reload.result }.from(nil).to('win')
        .and change { bet.reload.status }.from('pending').to('resolved')
    end
  end
end
