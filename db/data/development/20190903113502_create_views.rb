# frozen_string_literal: true

class CreateViews < SeedMigration::Migration
  def up
    Post.find_each do |post|
      (0..20).to_a.sample.times do
        user = User.order('RANDOM()').first

        next if user.views.where(post: post).any?

        post.views.create!(user: user)
      end
    end
  end

  def down; end
end
