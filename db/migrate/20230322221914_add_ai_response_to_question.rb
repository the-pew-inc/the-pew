class AddAiResponseToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :ai_response, :jsonb
  end
end
