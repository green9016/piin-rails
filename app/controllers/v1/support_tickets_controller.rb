# frozen_string_literal: true

module V1
  class SupportTicketsController < ApplicationController # :nodoc:
    before_action :set_support_ticket, only: %i[show update destroy]

    def index
      @support_tickets = current_user.support_tickets.ransack(params[:q])
      @support_tickets = sort_and_paginate(@support_tickets)

      meta_data = { currentPage: @support_tickets.current_page,
                    perPage: params[:perPage] || 10,
                    totalPages: @support_tickets.total_pages }

      render jsonapi: @support_tickets.uniq, include: %i[ticketable],
             meta: meta_data
    end

    def show
      render jsonapi: @support_ticket, include: %i[ticketable]
    end

    def create
      @support_ticket = current_user.support_tickets.new(support_ticket_params)

      if @support_ticket.save
        render jsonapi: @support_ticket, include: %i[ticketable],
               status: :created
      else
        render jsonapi_errors: @support_ticket.errors,
               status: :unprocessable_entity
      end
    end

    def update
      if @support_ticket.update(support_ticket_params)
        render jsonapi: @support_ticket, include: %i[ticketable]
      else
        render jsonapi_errors: @support_ticket.errors,
               status: :unprocessable_entity
      end
    end

    def destroy
      @support_ticket.destroy

      head :no_content
    end

    private

    def support_ticket_params
      params.permit(:query)
    end

    def set_support_ticket
      @support_ticket = current_user.support_tickets.find(params[:id])
    end
  end
end
