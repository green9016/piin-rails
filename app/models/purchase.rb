# frozen_string_literal: true

require 'csv'

class Purchase < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :pin
  has_one :firm, through: :pin

  def self.filter_by(params)
    return where(date: params[:date]) if params[:date]
    return all unless params[:start_date].present? && params[:end_date].present?

    where(date: params[:start_date]..params[:end_date])
  end

  def self.generate_csv(purchases)
    attributes = %w[id company_name stripe_id total email pin_id date]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      purchases.each do |purchase|
        csv << attributes.map { |attr| purchase.send(attr) }
      end
    end
  end
end
