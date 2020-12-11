class AddCloudinary < ActiveRecord::Migration[6.0]
  def change
    add_column :foods, :photo_asset_id, :string
    add_column :foods, :photo_public_id, :string
    add_column :foods, :photo_url, :string
    add_column :foods, :photo_file_name, :string

    add_column :proposals, :photo_asset_id, :string
    add_column :proposals, :photo_public_id, :string
    add_column :proposals, :photo_url, :string
    add_column :proposals, :photo_file_name, :string
  end
end
