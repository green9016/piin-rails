# frozen_string_literal: true

module V1
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_action :configure_permitted_parameters

    def destroy
      if @resource
        @resource.discard_user
        yield @resource if block_given?
        render_destroy_success
      else
        render_destroy_error
      end
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: signup_params)
      devise_parameter_sanitizer
        .permit(:account_update,
                keys: %i[username email first_name last_name photo birthday
                         phone password password_confirmation
                         settings_new_deals settings_timer])
    end

    private

    def signup_params
      %i[username email password password_confirmation photo birthday]
    end

    def account_update_params
      params.permit(%i[username email first_name last_name photo birthday
                       phone password password_confirmation
                       settings_new_deals settings_timer])
    end
  end
end
