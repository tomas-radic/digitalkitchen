class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients, id: :uuid do |t|
      t.references :part, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
      t.references :category, type: :uuid, null: true, foreign_key: { on_delete: :restrict }
      t.boolean :optional, null: false, default: false

      t.timestamps
    end
  end
end
