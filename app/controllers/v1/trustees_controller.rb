# frozen_string_literal: true

module V1
  class TrusteesController < ApplicationController # :nodoc:
    before_action :set_trustee, only: %i[update show destroy]
    before_action :check_firm, only: :create

    def index
      @trustees = current_user.trustees
      @trustees = @trustees.where(role: params[:role]) if params[:role].present?
      json_response(@trustees)
    end

    def create
      @trustee = Trustee.create!(trustee_params)
      json_response(@trustee, :created)
    end

    def update
      if params[:role].present? && params[:status].present?
        @trustee.update!(role: params[:role], status: params[:status])
        json_response(@trustee.reload)
      else
        render json: { message: "Role or Status can't be null", status: 422 },
               status: :unprocessable_entity
      end
    end

    def show
      json_response(@trustee)
    end

    def destroy
      @trustee.destroy
      head :no_content
    end

    private

    def set_trustee
      @trustee = Trustee.find(params[:id])
    end

    def trustee_params
      params.permit(:role, :status, :firm_id, :user_id)
    end

    def check_firm
      Firm.find(params[:firm_id])
    end
  end
end
