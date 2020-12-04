# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Sorting

  devise_token_auth_group :member, contains: %i[user business admin]
  #before_action :authenticate_member!
  #skip_before_action :authenticate_member!, if: :devise_controller?

  # CanCanCan, handle unauthorized access
  rescue_from CanCan::AccessDenied do |exception|
    render jsonapi_errors: { detail: exception.message }, status: :unauthorized
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render jsonapi_errors: { detail: exception.message }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render jsonapi_errors: { detail: exception.message },
           status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render jsonapi_errors: { detail: exception.message },
           status: :unprocessable_entity
  end

  rescue_from PaymentException do |exception|
    render jsonapi_errors: { detail: exception.message },
           status: :unprocessable_entity
  end
end
