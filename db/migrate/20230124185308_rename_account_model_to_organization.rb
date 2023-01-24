class RenameAccountModelToOrganization < ActiveRecord::Migration[7.0]
  def up
<<<<<<< HEAD

    # Rename the accounts table to organizations ONLY if the old accounts table exists
    if table_exists?(:accounts)
      rename_table :accounts, :organizations
    end
      
    # Rename the column account_id ONLY if it exists in the relative table.
    if Event.attribute_names.include? "account_id"
      rename_column :events, :account_id, :organization_id 
    end
    if Member.attribute_names.include? "account_id"
      rename_column :members, :account_id, :organization_id
    end
    if Question.attribute_names.include? "account_id"
      rename_column :questions, :account_id, :organization_id
    end
    if Room.attribute_names.include? "account_id"
      rename_column :rooms, :account_id, :organization_id
    end

    # renaming the indexes (done when migrating the column names)
    # ketp as a reference to the table structure before the change
    # rename_index :events, :index_events_on_account_id, :index_events_on_organization_id
    # rename_index :members, :index_members_on_account_id, :index_members_on_organization_id
    # rename_index :questions, :index_questions_on_account_id, :index_questions_on_organization_id
    # rename_index :rooms, :index_rooms_on_account_id, :index_rooms_on_organization_id
=======
    if table_exists?(:accounts)
      # renaming the account table to organization
      rename_table :accounts, :organizations

      # adjusting table names where needed
      rename_column :events, :account_id, :organization_id
      rename_column :members, :account_id, :organization_id
      rename_column :questions, :account_id, :organization_id
      rename_column :rooms, :account_id, :organization_id

      # renaming the indexes (done when migrating the column names)
      # ketp as a reference to the table structure before the change
      # rename_index :events, :index_events_on_account_id, :index_events_on_organization_id
      # rename_index :members, :index_members_on_account_id, :index_members_on_organization_id
      # rename_index :questions, :index_questions_on_account_id, :index_questions_on_organization_id
      # rename_index :rooms, :index_rooms_on_account_id, :index_rooms_on_organization_id
    end
>>>>>>> 9aab7f0 (Renaming Account into Organization)
  end
end
