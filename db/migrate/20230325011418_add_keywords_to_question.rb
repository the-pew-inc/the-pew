class AddKeywordsToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :keywords, :string, array: true, default: []
  end
end
