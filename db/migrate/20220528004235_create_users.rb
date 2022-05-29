class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :email, null: false
      t.string  :password_digest
      t.boolean :blocked, null: false, default: false

      # Confirmable
      t.boolean   :confirmed, null: false, default: false
      t.timestamp :confirmed_at

      # Account is locked
      t.boolean   :locked, null: false, default: false
      t.timestamp :locked_at
      t.integer   :failed_attempts, null: false, default: 0

      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :locked
    add_index :users, :blocked
  end
end
