# frozen_string_literal: true

class CreatePosts < SeedMigration::Migration
  def up
    Business.find_each do |business|
      (1..20).to_a.sample.times do
        post = business.posts.new(
          photo: File.open(Rails.root.join('spec/support/default.jpeg')),
          title: Faker::Lorem.sentence,
          kinds: %w[regular birthday holiday].sample,
          status: [0, 1].sample,
          checked: Faker::Boolean.boolean(0.2),
          firm: business.owned_firm,
        )

        (1..4).to_a.sample.times do
          post.offers << Offer.new(
            title: Faker::Lorem.characters,
            price: Faker::Boolean.boolean ? Faker::Number.decimal(2) : nil,
            percent: Faker::Number.number(2),
            week_days: [0, 4, 5, 6],
            start_time: '00:00',
            end_time: '23:00',
            status: [0, 1].sample
          )
        end

        post.save!
      end
    end
  end

  def down; end
end
