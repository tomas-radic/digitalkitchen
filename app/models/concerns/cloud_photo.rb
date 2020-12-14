module CloudPhoto
  extend ActiveSupport::Concern

  MAX_PHOTO_SIZE = 4.megabytes


  def update_photo(photo)
    return false if File.size(photo) > MAX_PHOTO_SIZE

    remove_photo if self.photo_public_id.present?
    upload_result = Cloudinary::Uploader.upload(photo, folder: "homefood")
    self.update(
        photo_asset_id: upload_result["asset_id"],
        photo_public_id: upload_result["public_id"],
        photo_url: upload_result["secure_url"],
        photo_file_name: upload_result["original_filename"]) if upload_result&.dig("secure_url")
  end


  def remove_photo
    remove_result = Cloudinary::Uploader.destroy(
        self.photo_public_id,
        invalidate: true)

    self.update(
        photo_asset_id: nil,
        photo_public_id: nil,
        photo_url: nil,
        photo_file_name: nil) if remove_result&.dig("result") == "ok"
  end


  def cloud_photo_url
    self.photo_url.presence || "https://res.cloudinary.com/diftw8ib1/image/upload/v1607611209/samples/food/fish-vegetables.jpg"
        # [
        #     "https://res.cloudinary.com/diftw8ib1/image/upload/v1607612263/homefood/sample_food_ihenrq.jpg",
        #     "https://res.cloudinary.com/diftw8ib1/image/upload/v1607611217/samples/food/spices.jpg",
        #     "https://res.cloudinary.com/diftw8ib1/image/upload/v1607611210/samples/food/pot-mussels.jpg",
        #     "https://res.cloudinary.com/diftw8ib1/image/upload/v1607611209/samples/food/fish-vegetables.jpg",
        #     "https://res.cloudinary.com/diftw8ib1/image/upload/v1607611208/samples/food/dessert.jpg"
        # ].sample
  end
end
