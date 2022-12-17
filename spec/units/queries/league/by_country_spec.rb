# frozen_string_literal: true

require 'rails_helper'

describe Queries::League do
  describe '.by_country' do
    subject { described_class.by_country(country_1) }

    let(:country_1) { create(:country, name: 'Belarus') }
    let(:country_2) { create(:country, name: 'England') }

    let(:league_1) { create(:league, name: 'First league', country: country_1) }
    let(:league_2) { create(:league, name: 'Second league', country: country_1) }
    let(:league_3) { create(:league, country: country_2) }

    before do
      country_1
      country_2

      league_1
      league_2
      league_3
    end

    it { is_expected.to contain_exactly(league_1, league_2) }
  end
end
