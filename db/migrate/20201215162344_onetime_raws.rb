class OnetimeRaws < ActiveRecord::Migration[6.0]
  def change
    add_column :raws, :is_onetime, :boolean, null: false, default: false
  end
end
