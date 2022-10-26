# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OddsportalScraper::Facade do
  describe '.get_something' do
    subject { described_class.get_something }

    it 'returns something' do
      expect(subject).to be 1
    end
  end
end
