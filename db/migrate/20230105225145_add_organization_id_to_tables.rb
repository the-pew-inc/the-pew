  class AddOrganizationIdToTables < ActiveRecord::Migration[7.1]
    disable_ddl_transaction!
    def up
      # Adding the organization_id column to Events, Rooms and Questions
      # Events
      add_column :events, :organization_id, :uuid
      add_index  :events, :organization_id, algorithm: :concurrently

      # Rooms
      add_column :rooms, :organization_id, :uuid
      add_index  :rooms, :organization_id, algorithm: :concurrently

      # Questions
      add_column :questions, :organization_id, :uuid
      add_index  :questions, :organization_id, algorithm: :concurrently

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

      # Add NOT NULL constraint
      add_not_null_constraint :events, :organization_id, name: "events_organization_id_null", validate: false
      add_not_null_constraint :rooms, :organization_id, name: "rooms_organization_id_null", validate: false
      add_not_null_constraint :questions, :organization_id, name: "questions_organization_id_null", validate: false

      # Validate the NOT NULL constraint
      validate_not_null_constraint :events, :organization_id, name: "events_organization_id_null"
      validate_not_null_constraint :rooms, :organization_id, name: "rooms_organization_id_null"
      validate_not_null_constraint :questions, :organization_id, name: "questions_organization_id_null"
    end

    def down
      remove_column :events, :organization_id, :uuid
      remove_column :rooms, :organization_id, :uuid
      remove_column :questions, :organization_id, :uuid
    end
  end