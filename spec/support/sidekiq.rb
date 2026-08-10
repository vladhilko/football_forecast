# frozen_string_literal: true

require 'sidekiq'

Sidekiq.testing!(:inline)
