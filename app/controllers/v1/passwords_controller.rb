# frozen_string_literal: true

module V1
  class PasswordsController < DeviseTokenAuth::PasswordsController
    private

    def resource_params
      params.permit(:email, :reset_password_token, :redirect_url)
    end
  end
end
