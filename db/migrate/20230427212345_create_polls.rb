class CreatePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :polls, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :user,         null: false, foreign_key: true, type: :uuid
      t.integer    :poll_type,    null: false
      t.string     :title,        null: false
      t.integer    :status,       null: false
      
      # Rules: 
      # 1. if num_answers AND max_answers are nil or equal to 0: a user can vote for as many poll_option present in the poll
      # 2. if num_answers OR max_answers is > 0 then we apply the rule assigned to each of these parameter
      # 3. if num_answers AND max_answers are > 0... then we have a problem
      t.integer    :num_answers # The strict number of poll_options a user must vote. If nil: unlimited
      t.integer    :max_answers # The maximim number of poll_options a user can vote. If nil: unlimited

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
