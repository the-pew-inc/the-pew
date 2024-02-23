class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups, id: :uuid do |t|
      t.references :user,         null: false, foreign_key: true, type: :uuid
      t.references :organization, null: false, foreign_key: false, type: :uuid
      t.string  :icon
      t.string  :name
      t.text    :description
      t.integer :group_type,      null: false, default: 0

      t.timestamps
    end

    add_index :groups, :group_type
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromGroupsToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :groups, :organizations
  end
end