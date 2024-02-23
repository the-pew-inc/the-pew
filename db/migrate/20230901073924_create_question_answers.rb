class CreateQuestionAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :question_answers, id: :uuid do |t|
      t.references :user,     null: false, foreign_key: true, type: :uuid
      t.references :question, null: false, foreign_key: false, type: :uuid

      t.timestamps
    end
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromQuestionAnswersToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :question_answers, :questions
  end
end