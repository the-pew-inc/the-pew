class CreateMeritActions < ActiveRecord::Migration[7.1]
  def change
    create_table :merit_actions, id: :uuid do |t|
      t.uuid :user_id
      t.string  :action_method
      t.integer :action_value
      t.boolean :had_errors, default: false
      t.string  :target_model
      t.integer :target_id
      t.text    :target_data
      t.boolean :processed, default: false
      t.timestamps null: false
    end

    add_index :merit_actions, :processed
  end
end
