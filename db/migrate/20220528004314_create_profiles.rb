class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.belongs_to :user,     null: false, foreign_key: true, type: :uuid
      t.string     :nickname
      t.integer    :mode,     null: false, default: 0

      t.timestamps
    end

    add_index :profiles, :mode
  end
end
