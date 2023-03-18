class AddToneToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :tone,  :integer, null: false, default: 0
    add_index  :questions, :tone
  end
end
