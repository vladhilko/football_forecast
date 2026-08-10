# frozen_string_literal: true

class TimeTravelSettlementJob < ApplicationJob

  queue_as :default

  def perform(session_id)
    session = TimeTravelSession.find(session_id)
    if session.reveal_deadline && Time.current < session.reveal_deadline
      self.class.set(wait_until: session.reveal_deadline).perform_later(session_id)
      return
    end

    Sportsbook::SettleSession.call(session:)
  end

end
