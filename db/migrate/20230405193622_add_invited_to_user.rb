# Add 3 fields to control how users are invited to join an organization
class AddInvitedToUser < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :users, :invited,    :boolean, null: false, default: false
    add_column :users, :invited_at, :timestamp
    add_column :users, :accepted_invitation_on, :timestamp

    add_index :users, :invited, algorithm: :concurrently
  end
end
