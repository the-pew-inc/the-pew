class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :plan,         null: false, foreign_key: true, type: :uuid
      t.string     :stripe_subscription_id
      t.boolean    :active,       null: false, default: false
      t.string     :period,       null: false
      t.date       :current_period_end
      t.date       :current_period_start
      

      t.timestamps
    end

    add_index :subscriptions, :stripe_subscription_id, unique: true
    add_index :subscriptions, :active
    add_index :subscriptions, :period
    add_index :subscriptions, :current_period_end
  end
end
