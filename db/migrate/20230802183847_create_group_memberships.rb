class CreateGroupMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :group_memberships, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :group, null: false, foreign_key: false, type: :uuid
      t.integer :role
      t.integer :status

      t.timestamps
    end
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromGroupMembershipsToGroups < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :group_memberships, :groups
  end
end