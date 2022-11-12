# frozen_string_literal: true

class BaseAuthorizer

  def initialize(entry_point)
    @entry_point = entry_point
  end

  def authorize!
    raise NotImplementedError
  end

  private

  attr_reader :entry_point

end
