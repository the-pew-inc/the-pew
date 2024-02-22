class AddRejectCauseIdToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :rejection_cause, :integer
    add_index  :questions, :rejection_cause
  end
end
