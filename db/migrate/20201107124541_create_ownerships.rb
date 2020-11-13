class CreateOwnerships < ActiveRecord::Migration[6.0]
  def change
    create_table :ownerships do |t|
      t.references :user, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
      t.references :raw, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
      t.boolean :need_buy, null: false, default: false
      t.date :expiration

      t.timestamps
    end
  end
end
