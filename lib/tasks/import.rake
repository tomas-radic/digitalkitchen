namespace :import do

  desc "Imports foods from json file(s)" # "rake import:food\[25\]" - to run with 25 as param
  task :food, [:food_json_id] => :environment do |t, args|

    food = nil
    food_json = JSON.parse File.read(Rails.root.join("lib", "import", "#{args[:food_json_id]}.json"))

    begin
      ActiveRecord::Base.transaction do
        food = Food.create!(
            name: food_json["name"],
            description: food_json["description"],
            food_category: FoodCategory.find_by!(name: food_json["category"]),
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

        puts "Food created!\n#{Rails.application.routes.url_helpers.food_path(food)}"
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      puts "Error while creating food\n#{e.message}"
    end
  end
end
