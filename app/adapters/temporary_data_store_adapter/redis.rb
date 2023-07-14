# frozen_string_literal: true

module TemporaryDataStoreAdapter
  class Redis

    def set(key, value)
      redis.set key, value.to_json
    end

    def get(key)
      return nil unless (value = redis.get(key))

      JSON.parse(value)
    end

    def delete(key)
      return nil unless (value = redis.getdel(key))

      JSON.parse(value)
    end

    private

    def redis
      @redis ||= ::Redis.new(url: ENV.fetch('REDIS_URL'))
    end

  end
end
