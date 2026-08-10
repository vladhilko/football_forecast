# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sportsbook::RoundSelector do
  it 'selects the next ten fixtures with twenty unique teams' do
    league = create(:league)
    season = create(:season, league:)
    10.times do |index|
      match = create(:match, season:, date: Date.new(2021, 12, 4) + (index / 5),
                             home_team: "Home #{index}", away_team: "Away #{index}")
      create(:betting_odds, match:)
    end

    round = described_class.call(league:, travel_on: Date.new(2021, 12, 1))

    expect(round.size).to eq(10)
    expect(round.flat_map { [_1.home_team, _1.away_team] }.uniq.size).to eq(20)
  end
end
