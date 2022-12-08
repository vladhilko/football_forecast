# frozen_string_literal: true

module Constants
  def self.season
    completeness_statuses = {
      initial: 'initial',
      full: 'full',
      partial: 'partial',
      ongoing: 'ongoing',
      empty: 'empty'
    }

    OpenStruct.new(
      completeness_statuses: OpenStruct.new(values: completeness_statuses.values, **completeness_statuses).freeze
    ).freeze
  end

  def self.match # rubocop:disable Metrics/MethodLength
    result_types = {
      cancelled: 'canc.'
    }

    results = {
      home_team_win: 'home_team_win',
      draw: 'draw',
      away_team_win: 'away_team_win'
    }

    OpenStruct.new(
      result_types: OpenStruct.new(values: result_types.values, **result_types).freeze,
      results: OpenStruct.new(values: results.values, **results).freeze
    ).freeze
  end
end
