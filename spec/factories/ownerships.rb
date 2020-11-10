FactoryBot.define do
  factory :ownership do
    association :user
    association :raw
  end
end
