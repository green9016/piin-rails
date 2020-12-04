# frozen_string_literal: true

require 'ruby-holidayapi'

class HolidayApiService
  def initialize
    @holiday_api = HolidayAPI::V1.new(ENV['HOLIDAY_API_KEY'])
  end

  def get_holiday_lists(params)
    ## params would be like this
    # params= {
    #   Required
    #    'country' => 'US',
    #    'year'    => 2016,
    #   Optional
    #    'month'    => 7,
    #    'day'      => 4,
    #    'previous' => true,
    #    'upcoming' => true,
    #    'public'   => true,
    #    'pretty'   => true,
    # }
    response = @holiday_api.holidays(params)
    response['holidays']
  rescue StandardError => e
    e.message
  end
end
