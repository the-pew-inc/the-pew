class AddAnonymousToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :anonymous, :boolean, null: false, default: false
    add_index  :questions, :anonymous
  end
end
