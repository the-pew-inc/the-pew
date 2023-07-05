class CreateFoodForThoughts < ActiveRecord::Migration[7.0]
  def change
    create_table :food_for_thoughts, id: :uuid do |t|
      t.string  :title,          null: false
      t.uuid    :organization_id
      t.uuid    :event_id
      t.string  :summary,        null: false
      t.string  :url
      t.boolean :sponsored,      null: false, default: false
      t.string  :sponsored_by
      t.string  :sponsored_utm

      t.timestamps
    end

    add_index :food_for_thoughts, :organization_id
    add_index :food_for_thoughts, :event_id
    add_index :food_for_thoughts, :sponsored
    add_index :food_for_thoughts, :sponsored_by
  end
end
