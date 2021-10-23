class Api::V1::MerchantSerializer
  include JSONAPI::Serializer

  attribute :name
  # has_many :items
end
