class CreateRaws < ActiveRecord::Migration[6.0]
  def change
    create_table :raws, id: :uuid do |t|
      t.string :name, null: false
      t.integer :regular_expiration_days
      t.references :category, type: :uuid, null: true, foreign_key: true

      t.timestamps
    end
  end
end
