# frozen_string_literal: true

module BusinessServices
  class ProfilePercentage
    BUSINESS_ATTRS = %w[email].freeze
    FIRM_ATTRS = %w[name about state city street zip phone_number
                    website business_type].freeze

    def initialize(business)
      @business = business
      @firm = business.owned_firm
    end

    def call
      attrs_count = business_attrs_count + firm_attrs_count
      total_attrs = (BUSINESS_ATTRS + FIRM_ATTRS).size 

      (attrs_count / total_attrs.to_f) * 100
    end

    private

    def business_attrs_count
      return 0 if @business.nil?

      BUSINESS_ATTRS.reduce(0) do |total, attr|
        @business[attr].present? ? total + 1 : total
      end
    end

    def firm_attrs_count
      return 0 if @firm.nil?

      FIRM_ATTRS.reduce(0) do |total, attr|
        @firm[attr].present? ? total + 1 : total
      end
    end
  end
end
