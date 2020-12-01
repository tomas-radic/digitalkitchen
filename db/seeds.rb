# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

ActiveRecord::Base.transaction do
  # ----------------------- Users -----------------------
  puts "\nAdding users..."
  User.where(email: "tomas.radic@gmail.com").first_or_create!(name: "dino", password: "asdfasdf")


  # ------------------ Food Categories -----------------
  puts "\nAdding food categories..."
  categories = [
      "Ázijská kuchyňa",
      "Talianska kuchyňa"
  ]

  categories.each do |name|
    FoodCategory.where(name: name).first_or_create!
  end


  # ----------------------- Raws -----------------------
  puts "\nAdding raws..."
  raws = {
      "Zelenina" => ["chilli papričky", "hrubá sladká paprika", "cibuľa", "šalotka", "cesnak"],
      "Koreniny" => ["čierne korenie", "zelené korenie", "rasca"],
      "Bylinky" => ["petržlenová vňať"],
      "Omáčky" => ["sojová omáčka"],
      "Mäsové výrobky" => ["kuracie prsia", "morčacie prsia", "oravská slanina", "anglická slanina", "pancetta"],
      "Mliečne výrobky" => ["parmezán", "pecorino"],
      nil => ["arašidy", "vajcia", "škrobová múčka", "kurací vývar", "dezertné víno", "olej",
              "soľ", "cukor", "sezam", "ryža", "špagety"]
  }

  raws.each do |category_name, raw_names|
    category = if category_name
                 RawCategory.where(name: category_name).first_or_create!
               end

    raw_names.each do |raw_name|
      raw = Raw.where(name: raw_name).first_or_create!
      category.raws << raw if category
    end
  end


  # ------------------ Random foods generator ------------------
  puts "\nAdding foods..."
  foods_to_generate = 32

  5.times do
    FoodCategory.where(name: Faker::Lorem.words(number: 1..2).join(' ')).first_or_create!
  end

  foods_to_generate.times do
    name = Faker::Food.dish

    Food.create!(
        name: name,
        food_category: FoodCategory.all.sample,
        owner: User.all.sample
    ).tap do |food|

      rand(1..3).times do
        food.parts.create!(
            name: Faker::Lorem.words(number: 1..3).join(' '),
            description: Faker::Lorem.sentences(number: 5..20).join(' ')
        ).tap do |part|

          ingredients_count = rand(4..8)

          ingredients_count.times do
            optional = rand(1..10) > 8
            part.ingredients.create!(optional: optional).tap do |ingredient|
              n = rand(1..10)
              alternatives_count = if n > 9
                                     3
                                   elsif n > 8
                                     2
                                   else
                                     1
                                   end

              alternatives_count.times do
                Alternative.create!(
                    ingredient: ingredient,
                    raw: Raw.all.sample
                )
              end
            end
          end
        end
      end
    end
  end


  puts "\nDone."
end
