class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.string     :stripe_product_id, null: false
      t.string     :label,             null: false
      t.boolean    :active,            null: false, default: false
      t.integer    :min_seats,         null: false, default: 1
      t.integer    :max_seats,         null: false, default: 1
      t.decimal    :price_mo, precision: 10, scale: 3 # pricing per mo per seat
      t.decimal    :price_y,  precision: 10, scale: 3 # pricing per year per seat
      t.string     :stripe_price_mo
      t.string     :stripe_price_y
      t.jsonb      :features,          null: false

      t.timestamps
    end

    add_index :plans, :stripe_product_id, unique: true
    add_index :plans, :active
  end
end
