class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.belongs_to :event,           null: false, foreign_key: true
      t.string     :name,            null: false
      t.boolean    :always_on,       null: false, default: false
      t.boolean    :allow_anonymous, null: false, default: false

      t.timestamps
    end

    add_index :rooms, :always_on
    add_index :rooms, :allow_anonymous
  end
end
