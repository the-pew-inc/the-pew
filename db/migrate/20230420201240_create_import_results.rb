class CreateImportResults < ActiveRecord::Migration[7.1]
  def change
    create_table :import_results, id: :uuid do |t|
      t.references :user,     null: false, foreign_key: true, type: :uuid
      t.string     :filename, null: false
      t.integer    :status,   null: false, default: 0
      t.text       :message

      t.timestamps
    end

    add_index :import_results, :status
  end
end
