# frozen_string_literal: true

RSpec.shared_context 'when platform settings are' do |name_and_settings|
  before do
    name_and_settings.each do |name, settings_data|
      allow(Settings::Platform::Repository).to receive(name).and_return(settings_data)
    end
  end
end
