# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Adapter do
  describe '#temporary_data_store' do
    subject { described_class.temporary_data_store }

    context 'when RAILS_ENV is test' do
      it { is_expected.to be_an_instance_of(TemporaryDataStoreAdapter::Memory) }
    end
  end
end
