class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, type: :uuid
      t.references :connector, null: false, type: :uuid
      t.integer    :throttle, null: false, default: 10
      t.string     :oauth_token
      t.string     :access_token
      t.string     :refresh_token
      t.string     :granted_scope, array: true, default: []
      t.integer    :status
      t.datetime   :last_refreshed_at
      t.boolean    :force_invalidation
      t.jsonb      :error_msg, default: {}
      t.jsonb      :usage_limits, default: {}
      t.jsonb      :settings, default: {}
      t.jsonb      :usage, default: {}
      t.boolean    :force_pull,      null: false, default: false
      t.boolean    :is_being_pulled, null: false, default: false
      t.timestamp  :token_expires_at
      t.timestamp  :pull_start_at
      t.timestamp  :last_pull_at

      t.timestamps
    end

    add_index :connections, :status
    add_index :connections, :force_invalidation
    add_index :connections, :force_pull
    add_index :connections, :is_being_pulled
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromUsersToConnections < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :connections, :users
  end
end
class AddForeignKeyFromConnectorsToConnections < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :connector, :connections
  end
end