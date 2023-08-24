class AddDetailsToRooms < ActiveRecord::Migration[7.0]
  def up
    # Add the room_type column
    add_column :rooms, :room_type, :integer

    # Add the end_date column without making it non-nullable yet
    add_column :rooms, :end_date, :datetime

    # Set the end_date value to be equal to start_date for existing records
    Room.update_all('end_date = start_date')

    # Now, change the end_date column to be non-nullable
    change_column_null :rooms, :end_date, false
  end

  def down
    remove_column :rooms, :room_type
    remove_column :rooms, :end_date
  end
end
