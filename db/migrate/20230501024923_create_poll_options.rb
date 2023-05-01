class CreatePollOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_options, id: :uuid do |t|
      t.references :poll,            null: false, foreign_key: true, type: :uuid
      t.uuid       :user_id
      t.boolean    :is_answer,       null: false, default: false
      t.string     :title
      t.integer    :points,          null: false, default: 0, limit: 2

      # True: enable user to type in free text using the title field
      # Defaults to false
      t.boolean    :title_enabled,   null: false, default: false 

      # Used to enable action_text based answers to let users write rich text answers
      # Defaults to false
      t.boolean    :text_answer_enabled,     null: false, default: false
      
      # Used to let users answer by uploading a document, image or else
      # Defaults to false
      t.boolean    :document_answer_enabled, null: false, default: false

      t.timestamps
    end

    add_index :poll_options, :user_id
  end
end
