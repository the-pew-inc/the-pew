class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.uuid :event_id # optional
      t.uuid :user_id  # optional
      t.uuid :room_id  # optional
      t.uuid :question_id # optional (debatable, but as polls and surveys will be added...)
      t.string :name, null: false # required (that's actually what stores the topic)
      t.text :description

      t.timestamps
    end

    add_index :topics, :name
    add_index :topics, :event_id
    add_index :topics, :user_id
    add_index :topics, :room_id
    add_index :topics, :question_id
  end
end
