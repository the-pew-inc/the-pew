class UpdatePoll < ActiveRecord::Migration[7.0]
  def change
    add_column :polls, :is_anonymous, :boolean, null: false, default: false
    remove_column :polls, :participants
  end
end
