class V1::UnshippedOrderSerializer
  include JSONAPI::Serializer

  attributes :potential_revenue, &:revenue
end
