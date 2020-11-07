class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps, id: :uuid do |t|
      t.references :part, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
      t.integer :position, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
