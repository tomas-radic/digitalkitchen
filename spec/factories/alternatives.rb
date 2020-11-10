FactoryBot.define do
  factory :alternative do
    association :ingredient
    association :raw
  end
end
