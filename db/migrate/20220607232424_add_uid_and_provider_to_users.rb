class AddUidAndProviderToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    
    add_index :users, :uid, unique: true, algorithm: :concurrently
    add_index :users, :provider, algorithm: :concurrently
  end
end
