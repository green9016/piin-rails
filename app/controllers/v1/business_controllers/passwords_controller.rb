# frozen_string_literal: true

module V1
  module BusinessControllers
    class PasswordsController < DeviseTokenAuth::PasswordsController
      private

      def resource_params
        params.permit(:email, :reset_password_token, :redirect_url)
      end
    end
  end
end
