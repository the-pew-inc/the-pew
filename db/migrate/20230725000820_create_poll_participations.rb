class CreatePollParticipations < ActiveRecord::Migration[7.1]
  def change
    create_table :poll_participations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :poll, null: false, foreign_key: false, type: :uuid

      t.timestamps
    end
  end
end

# Add additional foreign keys at the end
class AddForeignKeyFromPollParticipationsToPolls < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :poll_participations, :polls
  end
end