class CreateScoresAndPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :merit_scores, id: :uuid do |t|
      t.references :sash, type: :uuid
      t.string :category, default: 'default'
    end

    create_table :merit_score_points do |t|
      t.references :score, type: :uuid
      t.bigint :num_points, default: 0
      t.string :log
      t.datetime :created_at
    end
  end
end
