# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

ActiveRecord::Base.transaction do

  # ------------------ Random foods generator ------------------
  puts "\nAdding random fake foods..."
  foods_to_generate = 200

  categories_to_generate = (foods_to_generate / 20) + 1
  categories_to_generate = 5 if categories_to_generate > 5
  categories_to_generate.times do
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
