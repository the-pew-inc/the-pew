class CreateQuestions < ActiveRecord::Migration[7.1]
  def change

    # Create table without foreign key constraints
    # to minimize locking time on the table
    create_table :questions, id: :uuid do |t|
      t.belongs_to :user,   null: false, type: :uuid, foreign_key: true
      t.belongs_to :room,   null: false, type: :uuid, foreign_key: false
      t.string     :title,  null: false
      t.integer    :status, null: false, default: 0

      t.timestamps
    end

    # Add indices
    add_index :questions, [:user_id, :room_id]
    add_index :questions, :status
    add_index :questions, [:user_id, :status]
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromQuestionsToRoom < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :questions, :rooms
  end
end
