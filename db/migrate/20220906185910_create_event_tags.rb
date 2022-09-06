class CreateEventTags < ActiveRecord::Migration[7.0]
  def change
    create_table :event_tags do |t|
      t.belongs_to :account,    null: false, foreign_key: true 
      t.belongs_to :event,      null: false, foreign_key: true 
      t.belongs_to :room,       null: false, foreign_key: true

      t.string     :name,       null: false

      t.timestamps
    end

    add_index :event_tags, :name
  end
end
