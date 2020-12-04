# frozen_string_literal: true

module V1
  module BusinessControllers
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :configure_permitted_parameters

      def destroy
        if @resource
          @resource.discard_business
          yield @resource if block_given?
          render_destroy_success
        else
          render_destroy_error
        end
      end

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer
          .permit(:sign_up,
                  keys: [:email, :password, :password_confirmation,
                         owned_firm_attributes: owned_firm_attributes])

        devise_parameter_sanitizer
          .permit(:account_update,
                  keys: [:password, :password_confirmation,
                         :settings_new_deals, :settings_likes_and_views,
                         owned_firm_attributes: owned_firm_attributes])
      end

      def build_resource
        super

        return unless @resource

        @resource.build_owned_firm(name: params[:company_name],
                                   phone_number: params[:company_phone_number])
      end

      private

      def owned_firm_attributes
        [
          :id, :photo, :name, :about, :state, :city, :street, :zip,
          :phone_number, :website, :lat, :lng, :status, :business_type,
          schedules_attributes: [:id, :starts, :ends, :week_days],
          flags_attributes: [:id, :feature_id, :_destroy]
        ]
      end

      def account_update_params
        params.permit(:password, :password_confirmation,
                      :settings_new_deals, :settings_likes_and_views,
                      owned_firm_attributes: owned_firm_attributes)
      end
    end
  end
end
