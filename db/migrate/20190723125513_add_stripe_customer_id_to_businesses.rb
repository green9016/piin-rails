class AddStripeCustomerIdToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :stripe_customer_id, :string
  end
end
