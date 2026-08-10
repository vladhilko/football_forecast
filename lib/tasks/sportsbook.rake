# frozen_string_literal: true

namespace :sportsbook do
  desc 'Create an idempotent Premier League demo round for local development'
  task seed_demo: :environment do
    raise 'sportsbook:seed_demo is development-only' unless Rails.env.development?

    country = Country.find_or_create_by!(name: 'England')
    league = League.find_or_create_by!(country:, name: 'Premier League')
    if Match.joins(:season).where(seasons: { league_id: league.id }).count >= 10
      puts 'Premier League data already exists; demo round was not added.'
      next
    end

    season = Season.find_or_create_by!(league:, name: '2021/2022') do |record|
      record.completeness_status = Constants.season.completeness_statuses.full
      record.populated_at = Time.current
    end
    fixtures = [
      ['Arsenal', 'Newcastle United', '2:0', 1.55, 4.1, 6.2],
      ['Crystal Palace', 'Aston Villa', '1:2', 2.8, 3.25, 2.55],
      ['Liverpool', 'Southampton', '4:0', 1.22, 6.5, 12.0],
      ['Norwich City', 'Wolverhampton', '0:0', 3.5, 3.2, 2.18],
      ['Brighton', 'Leeds United', '0:0', 2.1, 3.5, 3.45],
      ['Brentford', 'Everton', '1:0', 2.7, 3.25, 2.65],
      ['Burnley', 'Tottenham Hotspur', '1:0', 4.6, 3.7, 1.78],
      ['Leicester City', 'Watford', '4:2', 1.66, 4.0, 4.9],
      ['Manchester City', 'West Ham United', '2:1', 1.28, 5.8, 10.0],
      ['Chelsea', 'Manchester United', '1:1', 1.65, 3.9, 5.2]
    ]
    fixtures.each_with_index do |(home, away, score, home_odds, draw_odds, away_odds), index|
      date = Date.new(2021, 11, 27) + (index / 5)
      match = Match.find_or_create_by!(season:, home_team: home, away_team: away, date:) do |record|
        record.time = Time.zone.parse(index < 5 ? '15:00' : '16:30')
        record.score = score
      end
      BettingOdds.find_or_create_by!(match:) do |odds|
        odds.home_team_win = home_odds
        odds.draw = draw_odds
        odds.away_team_win = away_odds
      end
    end
    puts 'Created a ten-match Premier League demo round beginning 2021-11-27.'
  end
end
