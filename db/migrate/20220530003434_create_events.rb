class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :user,       null: false, foreign_key: true 
      t.string     :name,       null: false
      t.datetime   :start_date, null: false
      t.datetime   :stop_date,  null: false
      t.integer    :duration

      t.timestamps
    end
  end
end
