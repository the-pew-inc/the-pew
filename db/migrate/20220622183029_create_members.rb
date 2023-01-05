class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members, id: :uuid do |t|
      t.references :user,    null: false, type: :uuid
      t.references :account, null: false, type: :uuid
      t.boolean    :owner,   null: false, default: false

      t.timestamps
    end

    add_index :members, :owner
  end
end
