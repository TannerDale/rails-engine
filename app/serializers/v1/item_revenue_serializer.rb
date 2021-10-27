class V1::ItemRevenueSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :unit_price, :merchant_id

  attribute :revenue, &:revenue
end
