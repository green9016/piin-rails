# frozen_string_literal: true

class FirmReport < ApplicationRecord
  belongs_to :firm
  has_one :owner, through: :firm

  def self.build_current(firm)
    build_for_month(firm, Time.zone.today.month, Time.zone.today.year)
  end

  def self.build_for_month(firm, month, year)
    new(
      firm: firm,
      month: month,
      year: year,
    ).tap do |firm_report|
      firm_report.update_data
    end
  end

  def pins
    Pin.where(firm_id: firm.id)
  end

  def users
    User.joins("INNER JOIN visited_locations ON users.id = visited_locations.user_id INNER JOIN pins ON visited_locations.pin_id = pins.id").where(pins: { firm_id: firm.id })
  end

  def like_dislikes
    LikeDislike.joins("INNER JOIN posts ON like_dislikes.post_id = posts.id").where(posts: { firm_id: firm.id })
  end

  def update_data
    assign_attributes(
      total_likes: calculate_total_likes,
      pins_purchased: calculate_pins_purchased,
      people_reached: calculate_people_reached,
      total_spent_cents: calculate_total_spent_cents,
      daily_spent_cents: calculate_daily_spent_cents,
    )
  end

  def total_pin_catalog_spent(pin_catalog)
    running_pins_for_pc = running_pins.where(pin_catalog: pin_catalog) 
    return 0 if running_pins_for_pc.empty?

    running_pins_for_pc.reduce(0) do |total, pin|
      base_date = pin.discarded_at || Time.zone.today
      last_date = [base_date, date.end_of_month].min
      days = ( last_date - date.beginning_of_month ).to_i

      total + ( pin.daily_price_in_cents * days )
    end
  end

  def daily_pin_catalog_spent(pin_catalog)
    running_pins_for_pc = running_pins.where(pin_catalog: pin_catalog)
    return 0 if running_pins_for_pc.empty?

    total_days = 0
    total_spent = running_pins_for_pc.reduce(0) do |total, pin|
      base_date = pin.discarded_at || Time.zone.today
      last_date = [base_date, date.end_of_month].min
      days = ( last_date - date.beginning_of_month ).to_i
      total_days = total_day + days

      total + ( pin.daily_price_in_cents * days )
    end

    total_spent / total_days.to_f
  end

  private

  def date
    Time.zone.today.change(month: month, year: year)
  end

  def calculate_total_likes
    like_dislikes.where(
      'like_dislikes.created_at >= :beginning_of_month AND like_dislikes.created_at <= :end_of_month',
      beginning_of_month: date.beginning_of_month,
      end_of_month: date.end_of_month
    ).count
  end

  def calculate_pins_purchased
    pins.where(
      'pins.created_at >= :beginning_of_month AND pins.created_at <= :end_of_month',
      beginning_of_month: date.beginning_of_month,
      end_of_month: date.end_of_month
    ).count
  end

  def calculate_people_reached
    users.where(
      'visited_locations.created_at >= :beginning_of_month AND visited_locations.created_at <= :end_of_month',
      beginning_of_month: date.beginning_of_month,
      end_of_month: date.end_of_month
    ).count
  end

  def running_pins
    pins.where(
      'pins.activated_on <= :beginning_of_month',
      beginning_of_month: date.beginning_of_month,
    )
  end

  def calculate_total_spent_cents
    return 0 if running_pins.empty?

    running_pins.reduce(0) do |total, pin|
      base_date = pin.discarded_at || Time.zone.today 
      last_date = [base_date, date.end_of_month].min
      days = ( last_date - date.beginning_of_month ).to_i

      total + ( pin.daily_price_in_cents * days )
    end
  end

  def calculate_daily_spent_cents
    return 0 if running_pins.empty?

    total_days = 0
    total_spent = running_pins.reduce(0) do |total, pin|
      base_date = pin.discarded_at || Time.zone.today
      last_date = [base_date, date.end_of_month].min
      days = ( last_date - date.beginning_of_month ).to_i
      total_days = total_day + days

      total + ( pin.daily_price_in_cents * days )
    end

    total_spent / total_days.to_f
  end
end
