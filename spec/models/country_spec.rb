# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country, type: :model do
  it { is_expected.to have_many(:leagues) }
end
