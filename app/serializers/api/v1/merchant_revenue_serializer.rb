class Api::V1::MerchantRevenueSerializer
  include JSONAPI::Serializer

  attribute :revenue, &:total_revenue
end
