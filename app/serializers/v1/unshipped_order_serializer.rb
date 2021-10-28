class V1::UnshippedOrderSerializer
  include JSONAPI::Serializer

  attribute :potential_revenue, &:revenue
end
