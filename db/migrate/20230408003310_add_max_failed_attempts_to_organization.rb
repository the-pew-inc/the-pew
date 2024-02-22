class AddMaxFailedAttemptsToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :max_failed_attempts, :integer, null: false, default: 5
    add_column :organizations, :failed_attempts_timeout, :integer, null: false, default: 900
  end
end
