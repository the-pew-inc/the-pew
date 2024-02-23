class AddPewPointsToProfile < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_column :profiles, :pew_points, :integer, null: false, default: 0
    add_index  :profiles, :pew_points, algorithm: :concurrently
  end
end
