class AddSsoFieldsToAccount < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :organizations, :domain,  :string
    add_column :organizations, :sso,     :boolean, null: false, default: false
    add_column :organizations, :dns_txt, :string
    add_column :organizations, :domain_verified,    :boolean, null: false, default: false
    add_column :organizations, :domain_verified_at, :timestamp

    add_index  :organizations, :domain,  unique: true, algorithm: :concurrently
    add_index  :organizations, :dns_txt, unique: true, algorithm: :concurrently
    add_index  :organizations, :sso, algorithm: :concurrently
    add_index  :organizations, :domain_verified, algorithm: :concurrently
  end
end
