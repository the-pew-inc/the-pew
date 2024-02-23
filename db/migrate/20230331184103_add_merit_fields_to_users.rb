class AddMeritFieldsToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :users, :sash_id, :uuid
    add_column :users, :level,   :integer, :default => 0

    add_index :users, :level, algorithm: :concurrently
    add_index :users, :sash_id, algorithm: :concurrently
  end
end
