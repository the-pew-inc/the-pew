class AddAccountIdToTables < ActiveRecord::Migration[7.0]
  def change
    # Events
    add_column :events, :account_id, :uuid
    add_index  :events, :account_id

    # Rooms
    add_column :rooms, :account_id, :uuid
    add_index  :rooms, :account_id

    # Questions
    add_column :questions, :account_id, :uuid
    add_index  :questions, :account_id
  end
end