class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :organization,     null: false, foreign_key: true, type: :uuid
      t.string     :customer_id,      null: false
      t.string     :stripe_plan,      null: false
      t.string     :subscription_id
      t.string     :status,           null: false
      t.boolean    :active,           null: false, default: false
      t.string     :interval,         null: false
      t.datetime   :current_period_end
      t.datetime   :current_period_start
      

      t.timestamps
    end

    
    add_index :subscriptions, :active
    add_index :subscriptions, :current_period_end
    add_index :subscriptions, :customer_id
    add_index :subscriptions, :interval
    add_index :subscriptions, :status
    add_index :subscriptions, :stripe_plan
    add_index :subscriptions, :subscription_id, unique: true
    
  end
end
      