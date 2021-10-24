FactoryBot.define do
  factory :customer do
    first_name { Faker::FunnyName.name }
    last_name { Faker::FunnyName.name }
  end
end
