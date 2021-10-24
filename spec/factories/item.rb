FactoryBot.define do
  factory :item do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.sentence }
    unit_price { (100..1000).to_a.sample }
    association :merchant
  end
end
