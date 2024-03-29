class CreateMeritActivityLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :merit_activity_logs, id: :uuid do |t|
      t.integer  :action_id
      t.string   :related_change_type
      t.integer  :related_change_id
      t.string   :description
      t.datetime :created_at
    end
  end
end
