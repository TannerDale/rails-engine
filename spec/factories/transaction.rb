FactoryBot.define do
  factory :transaction do
    result { %w[success failed].sample }
    credit_card_number { Faker::Number.number(digits: 16).to_s }
    credit_card_expiration_date { '12-2222' }
    association :invoice
  end
end
