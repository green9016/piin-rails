# frozen_string_literal: true

module V1
  class FlagsController < ApplicationController # :nodoc:
    before_action :set_flag, only: %i[update show destroy]

    def index
      @flags = if params[:firm_id].present?
                 Flag.kept.where(firm_id: params[:firm_id])
               else
                 @flags = Flag.kept
               end

      json_response(@flags)
    end

    def create
      @flag = Flag.create!(flag_params)
      json_response(@flag)
    end

    def update
      if params[:active].present?
        @flag.update!(active: params[:active])
        json_response(@flag.reload)
      else
        render json: { message: "Active value can't be null", status: 422 },
               status: :unprocessable_entity
      end
    end

    def show
      json_response(@flag)
    end

    def destroy
      @flag.destroy
      head :no_content
    end

    private

    def set_flag
      @flag = Flag.find(params[:id])
    end

    def flag_params
      params.permit(:feature_id, :firm_id, :active)
    end
  end
end
