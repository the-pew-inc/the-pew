class AddPewPointsToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :pew_points, :integer, null: false, default: 0
    add_index  :profiles, :pew_points
  end
end
