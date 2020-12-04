# frozen_string_literal: true

class AdminController < ApplicationController # :nodoc:
  def jsonapi_class
    super.merge(
      'Business': AdminSerializers::SerializableBusiness,
      'Firm': AdminSerializers::SerializableFirm,
      'Offer': AdminSerializers::SerializableOffer,
      'Pin': AdminSerializers::SerializablePin,
      'Post': AdminSerializers::SerializablePost,
      'Report': AdminSerializers::SerializableReport,
      'SupportTicket': AdminSerializers::SerializableSupportTicket,
      'User': AdminSerializers::SerializableUser
    )
  end
end
