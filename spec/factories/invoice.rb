FactoryBot.define do
  factory :invoice do
    status { %w[pending in_progress rejected].sample }
    association :customer
    association :merchant
  end
end
