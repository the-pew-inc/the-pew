class CreatePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :polls, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :user,         null: false, foreign_key: true, type: :uuid
      t.integer    :poll_type,    null: false
      t.string     :title,        null: false
      t.integer    :status,       null: false
      # Duration is used to display the poll a certain amount on time on the user's screen
      # When Duration is null, then the poll remains displayed
      t.integer    :duration
      t.boolean    :add_option,   null: false, default: true # Let user's add an option

      t.integer    :participants, null: false, default: 0

      t.timestamps
    end

    add_index :polls, :poll_type
    add_index :polls, :status
  end
end
