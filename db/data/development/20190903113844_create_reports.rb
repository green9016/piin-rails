# frozen_string_literal: true

class CreateReports < SeedMigration::Migration
  def up
    Post.find_each do |post|
      (0..5).to_a.sample.times do
        user = User.order('RANDOM()').first

        next if user.reports.where(post: post).any?

        post.reports.create!(
          user: user,
          description: Faker::Lorem.paragraph(4),
          wrong_location: Faker::Boolean::boolean(0.2),
          false_offers: Faker::Boolean::boolean(0.2),
          incorrect_open_hours: Faker::Boolean::boolean(0.2),
          different_business_name: Faker::Boolean::boolean(0.2),
          other_reason: Faker::Boolean::boolean(0.2),
        )
      end
    end
  end

  def down; end
end
