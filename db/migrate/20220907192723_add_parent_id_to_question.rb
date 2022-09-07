class AddParentIdToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :parent_id, :bigint
    add_index  :questions, :parent_id
  end
end
