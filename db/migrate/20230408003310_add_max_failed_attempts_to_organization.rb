class AddMaxFailedAttemptsToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :max_failed_attempts, :integer, null: false, default: 5
  end
end
