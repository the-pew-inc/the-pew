class AddStripeCustomerIdToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :stripe_customer_id, :string
    add_index  :organizations, :stripe_customer_id, unique: true
  end
end