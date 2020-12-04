# frozen_string_literal: true

module V1
  module AdminControllers
    class SupportTicketsController < ::AdminController # :nodoc:
      before_action :set_support_ticket, only: %i[show update destroy]

      def index
        @q = SupportTicket.ransack
        set_search
        @support_tickets = sort_and_paginate(@q)
        meta_data = { currentPage: @support_tickets.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @support_tickets.total_pages }

        render jsonapi: @support_tickets.uniq,
               include: %i[ticketable],
               meta: meta_data
      end

      # POST /support_tickets.json
      def create
        @support_ticket = SupportTicket.new(support_ticket_params)
        if @support_ticket.save
          render jsonapi: @support_ticket
        else
          render jsonapi_errors: @support_ticket.errors
        end
      end

      # PATCH/PUT /support_tickets/1.json
      def update
        if @support_ticket.update(support_ticket_params)
          render jsonapi: @support_ticket
        else
          render jsonapi_errors: @support_ticket.errors
        end
      end

      # GET /support_tickets/1.json
      def show
        render jsonapi: @support_ticket, include: [:ticketable]
      end

      # DELETE /support_tickets/1.json
      def destroy
        @support_ticket.destroy
        head :no_content
      end

      private

      def set_search
        search = params[:search]
        checked = nil
        if search == 'checked'
          checked = true
        elsif search == 'unchecked'
          checked = false
        end
        @q.build_grouping(m: 'or', id_eq: search, status_eq: search,
                          user_username_eq: search, user_email_eq: search,
                          checked_eq: checked, firm_name_cont: search)
      end

      def support_ticket_params
        params.permit(:user_id, :status, :description, :firm_id, :checked)
      end

      def set_support_ticket
        @support_ticket = SupportTicket.where(id: params[:id]).first
        return @support_ticket if @support_ticket

        render json: { errors: 'SupportTicket not found' }, status: 404
      end
    end
  end
end
