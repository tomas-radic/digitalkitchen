class CreateParts < ActiveRecord::Migration[6.0]
  def change
    create_table :parts, id: :uuid do |t|
      t.string :name, null: false
      t.references :food, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
      t.integer :sequence, null: false

      t.timestamps
    end
  end
end
