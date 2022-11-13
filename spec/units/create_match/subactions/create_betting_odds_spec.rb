# frozen_string_literal: true

require 'rails_helper'

describe CreateMatch::Subactions::CreateBettingOdds do
  subject { described_class.new(match:, params:).call }

  let(:match) { create(:match) }

  let(:params) do
    {
      home_team_win: 2.45,
      away_team_win: 2.54,
      draw: 3.03
    }
  end

  it 'creates a new betting odds record', :aggregate_failures do
    expect { subject }.to change(BettingOdds, :count).by(1)

    expect(subject).to have_attributes(
      home_team_win: 2.45,
      away_team_win: 2.54,
      draw: 3.03
    )
  end
end
