class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :user,       null: false, foreign_key: true 
      t.string     :name,       null: false
      t.datetime   :start_date, null: false
      t.datetime   :end_date,   null: false
      t.integer    :duration
      t.integer    :event_type, null: false
      t.integer    :status,     null: false, default: 0
      t.string     :short_code

      t.timestamps
    end

    add_index :events, :event_type
    add_index :events, :status
    add_index :events, :short_code
  end
end
