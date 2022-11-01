# frozen_string_literal: true

require 'rails_helper'

RSpec.describe League, type: :model do
  it { is_expected.to belong_to(:country) }
  it { is_expected.to have_many(:seasons) }
end
