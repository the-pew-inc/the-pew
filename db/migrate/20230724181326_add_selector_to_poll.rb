class AddSelectorToPoll < ActiveRecord::Migration[7.1]
  def change
    add_column :polls, :selectors, :string, array: true, default: ["upvote", "downvote", "neutral"]
    add_index  :polls, :selectors
  end
end
