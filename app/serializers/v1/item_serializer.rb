class V1::ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :merchant_id, :unit_price
end
