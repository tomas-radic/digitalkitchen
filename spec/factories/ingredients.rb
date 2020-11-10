FactoryBot.define do
  factory :ingredient do
    association :part

    trait :optional do
      optional { true }
    end
  end
end
