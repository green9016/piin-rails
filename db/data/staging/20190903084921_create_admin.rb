# frozen_string_literal: true

class CreateAdmin < SeedMigration::Migration
  def up
    Admin.find_or_create_by!(email: 'admin@email.com') do |admin|
      admin.username = 'admin'
      admin.password = '12345678'
    end

    Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
      admin.username = 'admin2'
      admin.password = '12345678'
    end
  end

  def down; end
end
