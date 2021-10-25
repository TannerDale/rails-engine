FactoryBot.define do
  factory :item do
    name { Faker::Coffee.blend_name }
    description { Faker::Coffee.notes }
    unit_price { (100..1000).to_a.sample }
    association :merchant
  end
end
