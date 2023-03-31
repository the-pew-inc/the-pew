class CreateScoresAndPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :merit_scores do |t|
      t.references :sash
      t.string :category, default: 'default'
    end

    create_table :merit_score_points do |t|
      t.references :score
      t.bigint :num_points, default: 0
      t.string :log
      t.datetime :created_at
    end
  end
end
