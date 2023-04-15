# frozen_string_literal: true

module Constant
  class Initialize

    def initialize(path)
      @path = path
    end

    def call
      hash = Constant::Load.new(path).call

      Kernel.const_set('Constants', Model.new(hash))
    end

    private

    attr_reader :path

  end
end
