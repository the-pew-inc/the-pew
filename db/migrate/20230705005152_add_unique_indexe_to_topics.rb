class AddUniqueIndexeToTopics < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_index :topics, [:question_id, :room_id, :user_id], unique: true, algorithm: :concurrently
  end
end
