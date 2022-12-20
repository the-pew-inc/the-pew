class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members, id: :uuid do |t|
      t.references :user,    null: false, type: :uuid, foreign_key: true
      t.references :account, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
