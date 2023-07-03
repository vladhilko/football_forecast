# frozen_string_literal: true

require 'rails_helper'

Dir[Rails.root.join('spec', 'lib', 'settings', 'platform', 'contracts', '**', '*.rb')].sort.each(&method(:require))

RSpec.describe Settings::Platform::Contracts do
  Dir.glob('config/settings/platform/*.yml').each do |settings_file|
    %w[first_platform second_platform third_platform].each do |platform|
      context "when checking #{settings_file} for #{platform}", current_platform: platform do
        subject do
          contract_class.new.call(platform_settings_content).errors.to_h
        end

        let(:contract_class) { "#{described_class}::#{File.basename(settings_file, '.yml').camelize}".constantize }
        let(:platform_settings_content) { YAML.load_file(settings_file).fetch(platform).deep_symbolize_keys }

        it { is_expected.to be_empty }
      end
    end
  end

  context 'when checking existing spec files' do
    let(:spec_contract_file_name_list) do
      Dir.glob(Rails.root.join('spec', 'lib', 'settings', 'platform', 'contracts', '*.rb'))
        .map { File.basename(_1, '.rb') }
    end

    let(:platform_settings_file_name_list) do
      Dir.glob(Rails.root.join('config', 'settings', 'platform', '*.yml'))
        .map { File.basename(_1, '.yml') }
    end

    it 'every contract is expected to have a matching platform settings file' do
      expect(spec_contract_file_name_list).to match_array(platform_settings_file_name_list)
    end
  end
end
