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
end
