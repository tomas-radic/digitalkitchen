FactoryBot.define do
  factory :food_category do
    name { SecureRandom.hex }
    type { "FoodCategory" }
  end

  factory :raw_category do
    name { SecureRandom.hex }
    type { "RawCategory" }
  end
end
