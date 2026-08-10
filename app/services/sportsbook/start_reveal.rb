# frozen_string_literal: true

module Sportsbook
  class StartReveal

    def self.call(session:)
      new(session:).call
    end

    def initialize(session:)
      @session = session
    end

    def call
      started = start!
      enqueue_settlement if started
      session
    end

    private

    attr_reader :session

    def start!
      session.with_lock do
        return false if session.status != 'betting'
        unless session.wagers.exists?
          raise Error.new('wager_required',
                          'Place at least one wager before moving time forward')
        end

        session.update!(status: 'revealing', reveal_started_at: Time.current)
        true
      end
    end

    def enqueue_settlement
      TimeTravelSettlementJob.set(wait_until: session.reveal_deadline).perform_later(session.id)
    end

  end
end
