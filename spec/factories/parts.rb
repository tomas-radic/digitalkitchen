FactoryBot.define do
  factory :part do
    association :food

    name { Faker::Lorem.words(number: 1..3).join(' ') }
    description { Faker::Lorem.sentences(number: 5..16).join(' ') }
  end
end
