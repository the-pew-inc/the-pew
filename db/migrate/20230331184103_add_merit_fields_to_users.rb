class AddMeritFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sash_id, :integer
    add_column :users, :level,   :integer, :default => 0

    add_index :users, :level
    add_index :users, :sash_id
  end
end
