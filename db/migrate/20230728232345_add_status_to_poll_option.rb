class AddStatusToPollOption < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :poll_options, :status, :integer, null: false, default: 0
    add_index  :poll_options, :status, algorithm: :concurrently
  end
end
