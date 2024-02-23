class AddDetailsToRooms < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def up
    # Add the end_date column without making it non-nullable yet
    add_column :rooms, :end_date, :datetime

    # Set the end_date value to be equal to start_date for existing records
    Room.update_all('end_date = start_date')

    # Now, change the end_date column to be non-nullable
    add_not_null_constraint :rooms, :end_date, name: "rooms_end_date_null", validate: false
    validate_not_null_constraint :rooms, :end_date, name: "rooms_end_date_null"

    change_column_null :rooms, :end_date, false
    remove_check_constraint :rooms, name: "rooms_end_date_null"
  end

  def down
    remove_column :rooms, :end_date
  end
end
