# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Constant::Initialize do
  describe '#call' do
    subject { described_class.new(path:, constant_name:).call }

    let(:path) { 'spec/fixtures/constants' }
    let(:constant_name) { 'MyConstant' }

    let(:hash_constant) do
      {
        'animal' => {
          'ages' => {
            'one_month' => '1 month',
            'one_week' => '1 week',
            'one_year' => '1 year'
          },
          'colors' => %w[green red white blue],
          'limit' => 10,
          'types' => %w[cat dog pig]
        },
        'car' => {
          'types' => %w[sedan minivan truck]
        }
      }
    end

    around do |example|
      subject
      example.run
      Kernel.send(:remove_const, constant_name)
    end

    it 'initialize a new constant with all hash values' do
      expect(MyConstant.animal.ages.one_month).to eq('1 month')
      expect(MyConstant.car.types.values).to eq(%w[sedan minivan truck])
    end
  end
end
