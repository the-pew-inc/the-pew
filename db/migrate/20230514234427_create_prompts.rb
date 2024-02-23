class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts, id: :uuid do |t|
      t.uuid    :organization_id
      t.string  :label,          null: false, limit: 50
      t.string  :title,          null: false, limit: 150
      t.string  :model
      t.text    :messages,       null: false
      t.text    :functions
      t.string  :function_call

      t.timestamps
    end

    add_index :prompts, [:label, :organization_id], unique: true
    add_index :prompts, :organization_id
    add_index :prompts, :model
  end
end
