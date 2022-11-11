# frozen_string_literal: true

require 'rails_helper'

describe Seasons::CompleteMatchesPopulation::EntryPoint do
  subject { described_class.call(season:) }

  let(:season) { create(:season, name: '2021/2022') }

  context 'when season populated all matches' do
    before do
      create(:match, season:, home_team: 'Arsenal', away_team: 'Liverpool')
      create(:match, season:, home_team: 'Liverpool', away_team: 'Arsenal')
    end

    it 'sets `completeness_status` to `full`' do
      expect { subject }.to change { season.reload.completeness_status }.from('initial').to('full')
    end
  end

  context 'when season populated not all matches' do
    before do
      create(:match, season:, home_team: 'Arsenal', away_team: 'Liverpool')
    end

    it 'sets `completeness_status` to `partial`' do
      expect { subject }.to change { season.reload.completeness_status }.from('initial').to('partial')
    end
  end

  context 'when 0 matches have been added' do
    it 'sets `completeness_status` to `empty`' do
      expect { subject }.to change { season.reload.completeness_status }.from('initial').to('empty')
    end
  end
end
