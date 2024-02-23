class CreatePollAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :poll_answers, id: :uuid do |t|
      t.references :user,        null: false, foreign_key: true, type: :uuid
      t.references :poll,        null: false, foreign_key: false, type: :uuid
      t.references :poll_option, null: false, foreign_key: false, type: :uuid

      t.string :title # Used when users can enter a free text under 250 chars long

      t.timestamps
    end
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromPollAnswersToPolld < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :poll_answers, :polls
  end
end

class AddForeignKeyFromPollAnswersToPollOptions < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :poll_answers, :poll_options
  end
end