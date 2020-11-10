FactoryBot.define do
  factory :food do
    association :owner, factory: :user
    name { Faker::Food.dish }

    trait :owner_private do
      owner_private { true }
    end
  end
end
