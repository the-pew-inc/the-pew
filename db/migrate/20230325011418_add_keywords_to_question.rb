class AddKeywordsToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :keywords, :string, array: true, default: []
  end
end
