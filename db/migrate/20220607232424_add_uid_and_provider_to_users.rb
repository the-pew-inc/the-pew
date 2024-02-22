class AddUidAndProviderToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    
    add_index :users, :uid, unique: true
    add_index :users, :provider
  end
end
