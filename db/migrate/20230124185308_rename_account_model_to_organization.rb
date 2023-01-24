class RenameAccountModelToOrganization < ActiveRecord::Migration[7.0]
  def up

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
  end
end
