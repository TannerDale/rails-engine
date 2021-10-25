FactoryBot.define do
  factory :invoice do
    status { %w[shipped returned packaged].sample }
    association :customer
    association :merchant
  end
end
