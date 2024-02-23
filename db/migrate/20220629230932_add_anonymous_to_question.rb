class AddAnonymousToQuestion < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :questions, :anonymous, :boolean, null: false, default: false
    add_index  :questions, :anonymous, algorithm: :concurrently
  end
end
