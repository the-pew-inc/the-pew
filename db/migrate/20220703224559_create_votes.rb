class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.belongs_to :user,     null: false, type: :uuid, foreign_key: true
      t.references :votable,  polymorphic: true, null: false
      t.integer    :choice,   default: 0

      t.timestamps
    end
  end
end
