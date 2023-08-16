class CreateResourceInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_invites, id: :uuid do |t|
      t.references :sender,       null: false, type: :uuid, index: true
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :recipient,    null: true, type: :uuid, index: true
      t.references :invitable,    polymorphic: true, null: false, type: :uuid
      t.uuid       :group_id
      t.datetime   :sent_on
      t.datetime   :expires_at
      t.string     :email
      t.string     :token,        null: false
      t.integer    :status
      t.string     :template
      t.text       :error_msg

      t.timestamps
    end

    # add foreign keys separately
    add_foreign_key :resource_invites, :users, column: :sender_id
    add_foreign_key :resource_invites, :users, column: :recipient_id

    # Indexes
    add_index :resource_invites, :status
    add_index :resource_invites, :email
    add_index :resource_invites, :group_id
    add_index :resource_invites, [:invitable_type, :invitable_id]
    add_index :resource_invites, :token, unique: true
  end
end
