class CreateProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :proposals, id: :uuid do |t|
      t.boolean :owner_private, null: false, default: false
      t.string :name,           null: false
      t.string :category
      t.string :ingredients,    null: false
      t.text :description,      null: false
      t.references :user, type: :uuid, null: false, foreign_key: { on_delete: :restrict }

      t.timestamps
    end
  end
end
