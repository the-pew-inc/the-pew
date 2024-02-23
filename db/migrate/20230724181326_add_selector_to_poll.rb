class AddSelectorToPoll < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :polls, :selectors, :string, array: true, default: ["upvote", "downvote", "neutral"]
    add_index  :polls, :selectors, algorithm: :concurrently
  end
end
