class Api::V1::ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :merchant_id

  attribute :unit_price do |i|
    i.unit_price.fdiv(100)
  end
end
