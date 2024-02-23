class AddParentIdToQuestion < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :questions, :parent_id, :uuid
    add_index  :questions, :parent_id,  algorithm: :concurrently
  end
end
