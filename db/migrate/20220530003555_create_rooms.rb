class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.string     :name,  null: false

      t.timestamps
    end
  end
end
