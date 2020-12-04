# frozen_string_literal: true

class User < ApplicationRecord
  include HasActive
  include Discard::Model

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable,
         authentication_keys: %i[username email]
  include DeviseTokenAuth::Concerns::User

  enum role: %i[user business admin]

  has_many :support_tickets, -> { merge(SupportTicket.kept) },
           as: :ticketable, dependent: :destroy
  has_many :orders, -> { merge(Order.kept) }, inverse_of: :user, dependent: :destroy
  has_many :alerts, -> { merge(Alert.kept) }, inverse_of: :user, dependent: :destroy
  has_many :notifications, through: :alerts
  has_many :trustees, -> { merge(Trustee.kept) }, inverse_of: :user, dependent: :destroy
  has_many :firms, through: :trustees
  has_many :locations, -> { merge(Location.kept) }, inverse_of: :user, dependent: :destroy
  has_many :views, -> { merge(View.kept) }, inverse_of: :user, dependent: :destroy
  has_many :purchases, -> { merge(Purchase.kept) }, inverse_of: :user
  has_many :visited_locations, -> { merge(VisitedLocation.kept) },
           inverse_of: :user, dependent: :destroy
  has_many :visited_pins, -> { distinct }, through: :visited_locations,
                                           source: :pin
  has_many :like_dislikes, -> { merge(LikeDislike.kept) }, inverse_of: :user, dependent: :destroy
  has_many :purchases, -> { merge(Purchase.kept) }, inverse_of: :user, dependent: :destroy
  has_many :user_posts, through: :like_dislikes, source: :post
  has_many :reports, -> { merge(Report.kept) }, inverse_of: :user, dependent: :destroy
  has_many :owned_firms, -> { merge(Firm.kept) }, class_name: 'Firm',
                                                  foreign_key: :owner_id

  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true
  validate :less_than_birthday

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  before_save :check_birthday_changed, on: :update

  mount_base64_uploader :photo, PhotoUploader

  # def self.create_user_from_fb(result)
  #   where(email: result['email']).first_or_create do |user|
  #     user.first_name = result['first_name']
  #     user.last_name = result['last_name']
  #     user.username = result['name'].delete(' ')
  #     user.birthday = result['birthday']
  #     user.password = Devise.friendly_token[0, 20]
  #     # TODO, how to take user's photo from Facebook?
  #     user.photo = File.open(Rails.root.join('spec/support/default.jpeg'))
  #   end
  # end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:username)
    query = 'lower(username) = ? OR lower(email) = ?'
    where(conditions).where(query, login.strip.downcase).first
  end

  def as_json(*)
    super.except('provider', 'uid', 'allow_password_change', 'status', 'role',
                 'created_at', 'updated_at', 'discarded_at', 'blocked',
                 'facebook_token', 'google_token').tap do |hash|
      hash['can_change_birthday'] = !user_changed_birthday?
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def likes
    like_dislikes.where(is_like: true)
  end

  def liked_posts
    user_posts.where(like_dislikes: { is_like: true })
  end

  def discard_user
    discard
    views.each(&:discard)
    purchases.each(&:discard)
    visited_locations.each(&:discard)
    like_dislikes.each(&:discard)
    purchases.each(&:discard)
    reports.each(&:discard)
    owned_firms.each(&:discard_firm)
    true
  end

  def discard_relationships
    support_tickets.each(&:discard)
    orders.each(&:discard)
    alerts.each(&:discard)
    trustees.each(&:discard)
    locations.each(&:discard)
  end

  def active_for_authentication?
    super && !discarded?
  end

  def inactive_message
    !discarded? ? super : :deleted_account
  end

  private

  def less_than_birthday
    return unless birthday.nil? || birthday >= Date.current

    errors.add(:birthday, 'greater than or equal to current date!')
  end

  def check_birthday_changed
    return unless persisted? && will_save_change_to_birthday?

    assign_attributes(user_changed_birthday: true)
  end
end
