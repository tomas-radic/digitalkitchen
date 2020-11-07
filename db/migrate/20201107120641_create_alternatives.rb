class CreateAlternatives < ActiveRecord::Migration[6.0]
  def change
    create_table :alternatives, id: :uuid do |t|
      t.references :ingredient, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
      t.references :raw, type: :uuid, null: false, foreign_key: { on_delete: :restrict }

      t.timestamps
    end
  end
end
