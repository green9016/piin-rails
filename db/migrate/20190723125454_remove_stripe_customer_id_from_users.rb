class RemoveStripeCustomerIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :stripe_customer_id, :string
  end
end
