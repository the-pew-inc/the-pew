class CreateConnectors < ActiveRecord::Migration[7.1]
  def change
    create_table :connectors, id: :uuid do |t|
      t.string :name,        null: false
      t.text   :description
      t.string :website
      t.string :github
      t.string :author
      t.string :version,     null: false

      t.timestamps
    end
  end
end
