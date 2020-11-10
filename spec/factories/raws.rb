FactoryBot.define do
  factory :raw do
    name { Faker::Lorem.words(number: 1..3).join(' ') }
  end
end
