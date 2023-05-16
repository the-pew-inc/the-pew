class CreateSubcriptionTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :subcription_transactions, id: :uuid do |t|
      t.references :subscriptions, null: false, foreign_key: true, type: :uuid
      t.string     :transaction_id
      t.string     :transaction_err
      t.string     :transaction_txt

      t.timestamps
    end
  end
end
