FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.number(digits: 3) }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    association :invoice
    association :merchant
  end
end
