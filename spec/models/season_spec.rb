# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Season, type: :model do
  it { is_expected.to belong_to(:league) }
end
