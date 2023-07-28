class RemoveDefaultFromChoiceInVotes < ActiveRecord::Migration[7.0]
  def change
    change_column_default :votes, :choice, nil
  end
end
