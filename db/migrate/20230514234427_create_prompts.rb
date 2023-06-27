class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts, id: :uuid do |t|
      t.uuid    :organization_id
      t.string  :label,          null: false, limit: 50
      t.string  :title,          null: false, limit: 50
      t.string  :model
      t.text    :message,        null: false
      t.text    :function

      t.timestamps
    end

    add_index :prompts, [:label, :organization_id], unique: true
    add_index :prompts, :organization_id
    add_index :prompts, :model
  end
end
