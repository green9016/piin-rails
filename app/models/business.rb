# frozen_string_literal: true

class Business < ApplicationRecord
  include Discard::Model
  include HasActive

  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
         :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :pins, -> { merge(Pin.kept) }, inverse_of: :business
  has_many :posts, -> { merge(Post.kept) }, inverse_of: :business
  has_many :payments, -> {merge(Payment.kept)}, inverse_of: :business
  has_one :owned_firm, class_name: 'Firm',
                       foreign_key: :owner_id, inverse_of: :owner
  has_many :support_tickets, as: :ticketable, dependent: :destroy

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :owned_firm, allow_destroy: false

  before_create :create_initial_pins

  def discard_business
    discard
    pins.each(&:discard_pin)
    posts.each(&:discard_post)
    payments.each(&:discard)
    owned_firm.discard_firm
    true
  end

  def active_for_authentication?
    super && !discarded?
  end

  def inactive_message
    !discarded? ? super : :deleted_account
  end

  def as_json(*)
    super.except('provider', 'uid', 'allow_password_change', 'status', 'role',
                 'created_at', 'updated_at', 'discarded_at', 'blocked',
                 'stripe_customer_id').tap do |hash|
      hash['company_id'] = owned_firm.id
      hash['company_name'] = owned_firm.name
      hash['company_photo'] = owned_firm.photo
      hash['company_about'] = owned_firm.about
      hash['company_street'] = owned_firm.street
      hash['company_state'] = owned_firm.state
      hash['company_city'] = owned_firm.city
      hash['company_zip'] = owned_firm.zip
      hash['company_phone_number'] = owned_firm.phone_number
      hash['company_website'] = owned_firm.website
      hash['company_business_type'] = owned_firm.business_type
      hash['company_lat'] = owned_firm.lat
      hash['company_lng'] = owned_firm.lng
      hash['company_available_balance'] = owned_firm.available_balance
      hash['company_likes_count'] = owned_firm.likes_count
      hash['company_pins_count'] = owned_firm.pins_count
      hash['company_reached_users_count'] = owned_firm.reached_users_count
      hash['company_schedules'] = owned_firm.schedules.map do |s|
        { id: s.id, starts: s.starts.strftime('%H:%M'), ends: s.ends.strftime('%H:%M'), week_days: s.week_days }
      end
      hash['company_features'] = owned_firm.features.map do |f|
        { id: f.id, name: f.name, icon: f.icon, description: f.description } 
      end
      hash['company_flags'] = owned_firm.flags
      hash['profile_percentage'] = BusinessServices::ProfilePercentage.new(self).call
    end
  end

  def create_initial_pins
    2.times do
      pc = PinCatalog.first
      pins.build(pin_catalog: pc, colour: pc.color, range: pc.range,
                 duration: pc.duration_in_days, lat: lat, lng: lng,
                 status: 1, firm: owned_firm,
                 daily_price_in_cents: pc.daily_price_in_cents,
                 icon: pc.icon, business: self)
    end
  end

  protected

  def send_confirmation_notification?
    true
  end
end
