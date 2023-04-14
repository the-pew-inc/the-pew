# Add 3 fields to control how users are invited to join an organization
class AddInvitedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :invited,    :boolean, null: false, default: false
    add_column :users, :invited_at, :timestamp
    add_column :users, :accepted_invitation_on, :timestamp

    add_index :users, :invited
  end
end
