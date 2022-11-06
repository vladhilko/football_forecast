# frozen_string_literal: true

module CreateMatch
  class Form < Dry::Struct

    include ::Form

    attribute :home_team, Types::String
    attribute :away_team, Types::String
    attribute :score, Types::String
    attribute :date, Types::String
    attribute :time, Types::String

  end
end
