# frozen_string_literal: true

class CreateLikeDislikes < SeedMigration::Migration
  def up
    Post.find_each do |post|
      (0..20).to_a.sample.times do
        user = User.order('RANDOM()').first
        next if user.like_dislikes.where(post: post).any?
        post.like_dislikes.create!(user: user, is_like: Faker::Boolean::boolean())
      end
    end
  end

  def down; end
end
