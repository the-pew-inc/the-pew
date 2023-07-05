class AddUniqueIndexeToTopics < ActiveRecord::Migration[7.0]
  def change
    add_index :topics, [:question_id, :room_id, :user_id], unique: true
  end
end
