# frozen_string_literal: true

require 'rails_helper'

describe Betting::ResolveBet::EntryPoint do
  subject { described_class.new(bet).call }

  let(:match) { create(:match, home_team: 'Arsenal', away_team: 'Chelsea', score: '2:1') }

  context 'when the bet is winning' do
    let(:bet) { create(:bet, match:, team: 'Arsenal', bet_type: 'win') }

    it 'resolve bet with `win` result', :aggregate_failures do
      expect { subject }.to change { bet.reload.result }.from(nil).to('win')
        .and change { bet.reload.status }.from('pending').to('resolved')
    end
  end

  context 'when bet type is lose' do
    let(:bet) { create(:bet, match:, team: 'Arsenal', bet_type: 'lose') }

    context 'when the team wins' do
      let(:match) { create(:match, home_team: 'Arsenal', away_team: 'Chelsea', score: '2:1') }

      it 'resolve the bet with `lose` result', :aggregate_failures do
        expect { subject }.to change { bet.reload.result }.from(nil).to('lose')
          .and change { bet.reload.status }.from('pending').to('resolved')
      end
    end

    context 'when the team loses' do
      let(:match) { create(:match, home_team: 'Arsenal', away_team: 'Chelsea', score: '1:2') }

      it 'resolve the bet with `win` result', :aggregate_failures do
        expect { subject }.to change { bet.reload.result }.from(nil).to('win')
          .and change { bet.reload.status }.from('pending').to('resolved')
      end
    end

    context 'when the team plays draw' do
      let(:match) { create(:match, home_team: 'Arsenal', away_team: 'Chelsea', score: '1:1') }

      it 'resolve the bet with `lose` result', :aggregate_failures do
        expect { subject }.to change { bet.reload.result }.from(nil).to('lose')
          .and change { bet.reload.status }.from('pending').to('resolved')
      end
    end
  end
end
