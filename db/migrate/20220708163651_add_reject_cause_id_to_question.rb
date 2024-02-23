class AddRejectCauseIdToQuestion < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :questions, :rejection_cause, :integer
    add_index  :questions, :rejection_cause, algorithm: :concurrently
  end
end
