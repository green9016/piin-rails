# frozen_string_literal: true

module HasWeekDays
  extend ActiveSupport::Concern

  included do
    validate :validate_week_days

    before_validation :prepare_week_days
  end

  def formatted_week_days
    return if week_days.blank?

    week_days.to_a.map do |wd|
      Date::DAYNAMES[wd.to_i]
    end
  end

  private

  def validate_week_days
    if week_days.blank? && !is_a?(Schedule)
      errors.add(:week_days, 'cannot be empty')
      return
    end

    errors.add(:week_days, 'has invalid days') if invalid_day?
  end

  def invalid_day?
    week_days.map(&:to_i).any? { |wd| wd.negative? || wd > 6 }
  end

  def prepare_week_days
    @week_days = week_days.uniq
  end
end
