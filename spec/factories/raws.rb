FactoryBot.define do
  factory :raw do
    name { SecureRandom.hex }

    trait :onetime do
      is_onetime { true }
    end
  end
end
