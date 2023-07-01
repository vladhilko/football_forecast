# frozen_string_literal: true

require_relative Rails.root.join('lib', 'constant', 'initialize.rb')

Constant::Initialize.new(path: 'config/constants', constant_name: 'Constants').call
