# frozen_string_literal: true

module TemporaryDataStoreAdapter
  class ActiveRecord

    def set(key, data)
      temp_data_entry = TemporaryDataEntry.find_by(key: key)

      if temp_data_entry.present?
        temp_data_entry.update(data: data)
      else
        TemporaryDataEntry.create(key: key, data: data)
      end
      'OK'
    end

    def get(key)
      TemporaryDataEntry.find_by(key: key)&.data
    end

    def delete(key)
      TemporaryDataEntry.find_by(key: key)&.delete&.data
    end

  end
end
