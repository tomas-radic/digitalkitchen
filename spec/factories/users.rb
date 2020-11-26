FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    password { "asdfasdf" }
  end
end
