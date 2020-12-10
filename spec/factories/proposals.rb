FactoryBot.define do
  factory :proposal do
    association :user

    name { Faker::Food.dish }
    ingredients { Faker::Lorem.words(number: rand(3..5)).join("\n") }
    description { Faker::Lorem.sentences(number: rand(4..7)).join(' ') }
  end
end
