# frozen_string_literal: true

class StatsDataService # :nodoc:
  def diff_results_count(result)
    result.where(created_at: cur_month_diff).count -
      result.where(created_at: pre_month_diff).count
  end

  def diff_active_results_count(result)
    result.active.where(created_at: cur_month_diff).count -
      result.active.where(created_at: pre_month_diff).count
  end

  def total_revenue_current_year
    @total = 0
    return @total if Pin.count.equal? 0

    total_pins = Pin.where(created_at: cur_year_diff)
    total_pins.each do |pin|
      @total += pin.remaining_balance unless pin.initial_balance_in_cents.blank?
    end
    @total
  end

  def total_revenue_last_year
    @total = 0
    return @total if Pin.count.equal? 0

    total_pins = Pin.where(created_at: last_year_diff)
    total_pins.each do |pin|
      @total += pin.remaining_balance unless pin.initial_balance_in_cents.blank?
    end
    @total
  end

  def total_revenue_yearly
    @total = 0
    return @total if Pin.count.equal? 0

    total_pins = Pin.all
    total_pins.each do |pin|
      @total += pin.remaining_balance unless pin.initial_balance_in_cents.blank?
    end
    @total
  end

  def total_revenue_current_month
    @total = 0
    return @total if Pin.count.equal? 0

    total_pins = Pin.where(created_at: cur_month_diff)
    total_pins.each do |pin|
      @total += pin.remaining_balance unless pin.initial_balance_in_cents.blank?
    end
    @total
  end

  def total_revenue_current_day
    @total = 0
    return @total if Pin.count.equal? 0

    total_pins = Pin.where(created_at: Date.today)
    total_pins.each do |pin|
      @total += pin.remaining_balance unless pin.initial_balance_in_cents.blank?
    end
    @total
  end

  def revenue_details_month(month)
    @total = 0
    return @total if Pin.count.equal? 0

    total_pins = Pin.where(created_at: month_diff(month))
    total_pins.each do |pin|
      @total += pin.remaining_balance unless pin.initial_balance_in_cents.blank?
    end
    @total
  end

  private

  def pre_month_diff
    (Date.today - 1.month).beginning_of_month..
      (Date.today - 1.month).end_of_month
  end

  def cur_month_diff
    Date.today.beginning_of_month..Date.today.end_of_month
  end

  def cur_year_diff
    Date.today.beginning_of_year..Date.today.end_of_year
  end

  def last_year_diff
    (Date.today - 1.year).beginning_of_year..
    (Date.today - 1.year).end_of_year
  end

  def month_diff(month, year = Date.today.year)
    date = Date.parse("#{year}-#{month}-01")
    date.beginning_of_month..date.end_of_month
  end
end
