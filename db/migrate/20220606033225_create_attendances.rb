class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances, id: :uuid do |t|
      t.references :user,  null: false, type: :uuid, foreign_key: true
      t.references :event, null: false, type: :uuid, foreign_key: true
      t.references :room
      t.integer    :status, null: false, default: 0
      t.datetime   :start_time, null: false
      t.datetime   :end_time

      t.timestamps
    end
  end
end
