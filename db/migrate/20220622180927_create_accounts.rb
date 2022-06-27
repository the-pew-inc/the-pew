class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :website
      t.string :country

      t.timestamps
    end

    add_index :accounts, :country
  end
end
