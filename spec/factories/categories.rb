FactoryBot.define do
  factory :food_category do
    name { Faker::Lorem.word }
    type { "FoodCategory" }
  end

  factory :raw_category do
    name { Faker::Lorem.word }
    type { "RawCategory" }
  end
end
