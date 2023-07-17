# frozen_string_literal: true

module TemporaryDataStoreAdapter
  class Memory

    def initialize
      @store = {}
    end

    def set(key, value)
      @store[key.to_s] = value.to_json
      'OK'
    end

    def get(key)
      return nil unless (value = @store[key.to_s])

      JSON.parse(value)
    end

    def delete(key)
      return nil unless (value = @store[key.to_s])

      @store.delete key.to_s
      JSON.parse(value)
    end

    def clear
      @store.clear
    end

  end
end
