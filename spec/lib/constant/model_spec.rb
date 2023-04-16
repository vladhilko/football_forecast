# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Constant::Model do
  describe '#deep_transform' do
    subject(:constant) { described_class.new(hash_constant).deep_transform }

    let(:hash_constant) do
      {
        'animal' => {
          'ages' => {
            'one_month' => '1 month',
            'one_week' => '1 week',
            'one_year' => '1 year'
          },
          'colors' => %w[green red white green],
          'limit' => 10,
          'types' => %w[cat dog pig]
        },
        'car' => {
          'types' => %w[sedan minivan truck]
        }
      }
    end

    describe 'constant freeze' do
      it 'raises FrozenError when trying to modify the constant' do
        expect { constant.animal.colors.green << 'update' }.to raise_error(FrozenError)
      end

      it 'raises FrozenError when trying to add something to the constant' do
        expect { constant.animal.colors['new_key'] = 'new_key' }.to raise_error(FrozenError)
      end
    end

    it 'uses symbol keys instead of string for all nested levels' do
      expect(constant.keys.all?(Symbol)).to be true
      expect(constant.animal.keys.all?(Symbol)).to be true
      expect(constant.animal.ages.keys.all?(Symbol)).to be true
      expect(constant.animal.colors.keys.all?(Symbol)).to be true

      expect(constant.car.keys.all?(Symbol)).to be true
      expect(constant.car.types.keys.all?(Symbol)).to be true
    end

    it 'defines methods for each hash key and array' do
      expect(constant.animal.colors.green).to eq('green')
      expect(constant.car.types.sedan).to eq('sedan')

      expect(constant.animal.ages.one_month).to eq('1 month')
    end
  end
end
