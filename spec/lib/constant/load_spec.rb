# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Constant::Load do
  subject { described_class.new(path).call }

  let(:path) { 'spec/fixtures/constants' }

  it 'loads all constants yml files and transform them to one hash' do
    expect(subject).to eq(
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
    )
  end
end
