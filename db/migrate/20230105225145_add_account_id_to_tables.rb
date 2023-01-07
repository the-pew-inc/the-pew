class AddAccountIdToTables < ActiveRecord::Migration[7.0]
  def up
    # Adding the account_id column to Events, Rooms and Questions
    # Events
    add_column :events, :account_id, :uuid
    add_index  :events, :account_id

    # Rooms
    add_column :rooms, :account_id, :uuid
    add_index  :rooms, :account_id

    # Questions
    add_column :questions, :account_id, :uuid
    add_index  :questions, :account_id

    # Filling with proper data
    # Events
    Event.where(account_id: nil).each do |event|
      event.update(account_id: Member.where(user_id: event.user_id).first.account_id)
    end

    # Rooms
    Room.where(account_id: nil).each do |room|
      room.update(account_id: Member.where(user_id: room.event.user_id).first.account_id)
    end

    # Questions
    Question.where(account_id: nil).each do |question|
      question.update(account_id: Member.where(user_id: question.room.event.user_id).first.account_id)
    end

    # Making not null the new default
    # Events
    change_column_null :events, :account_id, false

    # Rooms
    change_column_null :rooms, :account_id, false

    # Questions
    change_column_null :questions, :account_id, false
  end

  def down
    remove_column :events, :account_id, :uuid
    remove_column :rooms, :account_id, :uuid
    remove_column :questions, :account_id, :uuid
  end
end