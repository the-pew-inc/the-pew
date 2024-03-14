class CreateConnectors < ActiveRecord::Migration[7.1]
  def change
    create_table :connectors, id: :uuid do |t|
      t.string  :name,         null: false
      t.string  :redirect_url, null: false
      t.string  :website
      t.string  :github
      t.string  :author
      t.string  :version,      null: false
      t.boolean :enabled,      null: false, default: false
      t.boolean :verified,     null: false, default: false
      t.jsonb   :settings,     null: false, default: {}

      t.timestamps
    end

    add_index :connectors, :enabled
    add_index :connectors, :name, unique: true
    add_index :connectors, :verified
  end
end
