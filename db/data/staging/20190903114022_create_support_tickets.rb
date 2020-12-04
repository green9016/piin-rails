# frozen_string_literal: true

class CreateSupportTickets < SeedMigration::Migration
  def up
    10.times do
      SupportTicket.create!(
        ticketable: User.order('RANDOM()').first,
        query: Faker::Lorem.paragraph(4)
      )
    end
  end

  def down; end
end
