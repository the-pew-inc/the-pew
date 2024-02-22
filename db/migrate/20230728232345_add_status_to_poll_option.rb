class AddStatusToPollOption < ActiveRecord::Migration[7.1]
  def change
    add_column :poll_options, :status, :integer, null: false, default: 0
    add_index  :poll_options, :status
  end
end
