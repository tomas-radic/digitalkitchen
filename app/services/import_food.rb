class ImportFood < BaseService

  def initialize(file_path)
    @file_path = file_path
  end


  def call
    if !File.exist?(@file_path) || !@file_path.to_s.match?(/\.json$/)
      puts "Aborted, incorrect file name."
      return
    end

    food = nil
    error_message = nil
    food_json = JSON.parse File.read(@file_path)

    begin
      ActiveRecord::Base.transaction do
        food = Food.create!(
            name: food_json["name"],
            description: food_json["description"],
            food_category: FoodCategory.where(name: food_json["category"]).first_or_create!,
            owner: User.find_by!(email: food_json["owner"]),
            owner_private: food_json["owner_private"] || false
        )

        json_parts = food_json["parts"]
        json_parts.each do |json_part|
          part = food.parts.create!(
              name: json_part["name"],
              description: json_part["description"]
          )

          json_ingredients = json_part["ingredients"]
          json_ingredients.each do |json_ingredient|
            ingredient = part.ingredients.create!(optional: json_ingredient["optional"])

            json_alternatives = json_ingredient["alternatives"]
            json_alternatives.each do |json_alternative|
              ingredient.alternatives.create!(raw: Raw.find_by!(name: json_alternative["name"]))
            end
          end
        end


      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      error_message = e.message
    end

    food || error_message
  end
end
