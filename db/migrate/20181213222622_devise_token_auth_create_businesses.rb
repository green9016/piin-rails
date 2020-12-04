# frozen_string_literal: true

class DeviseTokenAuthCreateBusinesses < ActiveRecord::Migration[5.2]
  def change
    create_table(:businesses) do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :allow_password_change, default: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using reconfirmable

      ## Tackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Admin Info
      t.string :email
      t.string :username
      t.string :photo
      t.string :first_name
      t.string :last_name
      t.date :birthday
      t.string :facebook_token
      t.float :lat, null: false, default: 0.0
      t.float :lng, null: false, default: 0.0
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false
      t.integer :role

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :businesses, :email, unique: true
    add_index :businesses, %i[uid provider], unique: true
    add_index :businesses, :reset_password_token, unique: true
    add_index :businesses, :confirmation_token, unique: true
    # add_index :businesses, :unlock_token,       unique: true
  end
end
