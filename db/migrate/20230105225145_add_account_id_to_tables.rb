class AddAccountIdToTables < ActiveRecord::Migration[7.0]
  def up
    # Adding the organization_id column to Events, Rooms and Questions
    # Events
    add_column :events, :organization_id, :uuid
    add_index  :events, :organization_id

    # Rooms
    add_column :rooms, :organization_id, :uuid
    add_index  :rooms, :organization_id

    # Questions
    add_column :questions, :organization_id, :uuid
    add_index  :questions, :organization_id

    # Filling with proper data
    # Events
    Event.where(organization_id: nil).each do |event|
      event.update(organization_id: Member.where(user_id: event.user_id).first.organization_id)
    end

    # Rooms
    Room.where(organization_id: nil).each do |room|
      room.update(organization_id: Member.where(user_id: room.event.user_id).first.organization_id)
    end

    # Questions
    Question.where(organization_id: nil).each do |question|
      question.update(organization_id: Member.where(user_id: question.room.event.user_id).first.organization_id)
    end

    # Making not null the new default
    # Events
    change_column_null :events, :organization_id, false

    # Rooms
    change_column_null :rooms, :organization_id, false

    # Questions
    change_column_null :questions, :organization_id, false
  end

  def down
    remove_column :events, :organization_id, :uuid
    remove_column :rooms, :organization_id, :uuid
    remove_column :questions, :organization_id, :uuid
  end
end