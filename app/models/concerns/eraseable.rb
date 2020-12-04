# frozen_string_literal: true

module Eraseable
  extend ActiveSupport::Concern

  def can_be_erase?
    disabled?
  end

  def disabled?
    disabled_at.present? && disabled_at <= Time.zone.now
  end

  def disable!
    self.disabled_at = Time.zone.now
    save!
  end
end
