class AddColumnsToPrompts < ActiveRecord::Migration[7.0]
  def change
    add_column :prompts, :model, :string, null: false, default: 'gpt-3.5'
    add_column :prompts, :function, :string

    # Add an index on the 'model' column
    add_index :prompts, :model
  end
end
