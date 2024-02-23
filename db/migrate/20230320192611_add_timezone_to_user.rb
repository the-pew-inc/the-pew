class AddTimezoneToUser < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :users, :time_zone, :string
    add_index  :users, :time_zone, algorithm: :concurrently
  end
end
