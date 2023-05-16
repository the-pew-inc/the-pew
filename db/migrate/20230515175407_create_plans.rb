class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans, id: :uuid do |t|
      t.references :subscription,      null: false, foreign_key: true, type: :uuid
      t.string     :stripe_product_id
      t.string     :label,             null: false
      t.boolean    :active,            null: false
      t.string     :currency,          null: false, default: 'USD'
      t.integer    :price,             null: false #saved in cents $14.5 is 1450
      t.jsonb      :features,          null: false

      t.timestamps
    end

    add_index :plans, :stripe_product_id
    add_index :plans, :active
    add_index :plans, :currency
  end
end
