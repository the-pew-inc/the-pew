class CreateEventTags < ActiveRecord::Migration[7.0]
  def change
    create_table :event_tags do |t|
      t.belongs_to :account,    null: false, foreign_key: true 
      t.belongs_to :event,      null: false, foreign_key: true 
      t.belongs_to :room,       null: false, foreign_key: true
      t.belongs_to :user,       null: false, foreign_key: true 

      t.string     :name,       null: false
      t.boolean    :user_only,  null: false, default: false # All the users attached to the same account can access the tags. Set to true if you want a tag to only be accessible to a user

      t.timestamps
    end

    add_index :event_tags, :name
    add_index :event_tags, :user_only
    add_index :event_tags, [:user, :user_only]
  end
end
