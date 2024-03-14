class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, type: :uuid
      t.references :connector, null: false, type: :uuid
      t.integer    :throttle, null: false, default: 10
      t.string     :oauth_token
      t.string     :refresh_token
      t.integer    :status
      t.datetime   :last_refreshed_at
      t.boolean    :force_invalidation
      t.jsonb      :errors, default: {}
      t.jsonb      :usage_limits, default: {}
      t.jsonb      :settings, default: {}
      t.jsonb      :usage, default: {}

      t.timestamps
    end

    add_index :connections, :status
    add_index :connections, :force_invalidation
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