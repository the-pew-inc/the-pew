class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts, id: :uuid do |t|
      t.string  :label,          null: false, limit: 50
      t.string  :title,          null: false, limit: 50
      t.uuid    :organization_id
      t.text    :prompt,         null: false

      t.timestamps
    end

    add_index :prompts, [:label, :organization_id], unique: true
    add_index :prompts, :organization_id
  end
end
