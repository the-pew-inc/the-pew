class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.belongs_to :user,   null: false, type: :uuid, foreign_key: true
      t.belongs_to :room,   null: false, type: :uuid, foreign_key: true
      t.string     :title,  null: false
      t.integer    :status, null: false, default: 0

      t.timestamps
    end

    add_index :questions, [:user_id, :room_id]
    add_index :questions, :status
    add_index :questions, [:user_id, :status]
  end
end
