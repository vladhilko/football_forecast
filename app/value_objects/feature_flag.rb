# frozen_string_literal: true

class FeatureFlag

  class << self

    def all
      Constants.feature_flags
    end

    def supported?(flag_name)
      supported_names.include?(flag_name.to_s)
    end

    def supported_names
      all.pluck(:name)
    end

  end

end
