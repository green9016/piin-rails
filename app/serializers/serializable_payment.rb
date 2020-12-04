# frozen_string_literal: true

class SerializablePayment < JSONAPI::Serializable::Resource
  type 'payments'

  attributes :business_id, :firm_id, :pin_id,
             :amount_in_cents, :stripe_charge_id

  belongs_to :business
  belongs_to :firm
  belongs_to :pin
end
