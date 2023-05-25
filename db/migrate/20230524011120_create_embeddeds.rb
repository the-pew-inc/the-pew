class CreateEmbeddeds < ActiveRecord::Migration[7.0]
  def change
    create_table :embeddeds, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :user,         null: false, foreign_key: true, type: :uuid
      t.string     :token,        null: false
      t.string     :path  # The path, usualy :controller/:action/:id but can be different in the case of questions the path is going to be rooms/:room_id/questions/new
      t.string     :label # Add a description to the Embedded

      t.timestamps
    end
    add_index :embeddeds, :token, unique: true
    add_index :embeddeds, :path,  unique: true
  end
end
