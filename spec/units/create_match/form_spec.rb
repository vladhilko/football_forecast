# frozen_string_literal: true

require 'rails_helper'

describe CreateMatch::Form do
  describe '#attributes' do
    subject(:attributes) { described_class.new(params).attributes }

    let(:params) do
      {
        home_team: 'Arsenal',
        away_team: 'Chelsea',
        score: '2:1',
        date: '01.12.2010',
        time: '17:00'
      }
    end

    it 'returns correct attributes' do
      expect(attributes).to eq(
        {
          home_team: 'Arsenal',
          away_team: 'Chelsea',
          score: '2:1',
          date: '01.12.2010',
          time: '17:00'
        }
      )
    end
  end
end
