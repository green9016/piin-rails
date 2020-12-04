# frozen_string_literal: true

module V1
  class SessionsController < DeviseTokenAuth::SessionsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer
        .permit(:sign_in, keys: %i[username email password])
    end
  end
end
