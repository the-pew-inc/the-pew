class AddSsoFieldsToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :domain,  :string
    add_column :accounts, :sso,     :boolean, null: false, default: false
    add_column :accounts, :dns_txt, :string
    add_column :accounts, :domain_verified,    :boolean, null: false, default: false
    add_column :accounts, :domain_verified_at, :timestamp

    add_index  :accounts, :domain,  unique: true
    add_index  :accounts, :dns_txt, unique: true
    add_index  :accounts, :sso
    add_index  :accounts, :domain_verified
  end
end
