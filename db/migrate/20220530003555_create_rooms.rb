class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms, id: :uuid do |t|
      t.belongs_to :event,           null: false, type: :uuid, foreign_key: true
      t.string     :name,            null: false
      t.boolean    :always_on,       null: false, default: false
      t.boolean    :allow_anonymous, null: false, default: false
      t.datetime   :start_date,      null: false

      t.timestamps
    end

    add_index :rooms, :always_on
    add_index :rooms, :allow_anonymous
    add_index :rooms, :start_date
  end
end
