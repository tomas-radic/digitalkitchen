FactoryBot.define do
  factory :raw do
    name { Faker::Food.ingredient }
  end
end
