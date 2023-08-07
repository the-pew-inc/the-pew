class AddGroupIdToResourceInvites < ActiveRecord::Migration[7.0]
  def change
    add_column :resource_invites, :group_id, :uuid
    add_index  :resource_invites, :group_id
  end
end
