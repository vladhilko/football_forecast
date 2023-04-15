# frozen_string_literal: true

module Constant
  class Load

    def initialize(path)
      @path = path
    end

    def call
      Dir.glob(File.join(path, '*.yml')).reduce({}) do |hash, file_path|
        hash.merge(YAML.load_file(file_path, symbolize_names: true))
      end
    end

    private

    attr_reader :path

  end
end
