class AddParentIdToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :parent_id, :uuid
    add_index  :questions, :parent_id
  end
end
