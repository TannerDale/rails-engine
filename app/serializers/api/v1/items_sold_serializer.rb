class Api::V1::ItemsSoldSerializer
  include JSONAPI::Serializer

  attributes :name, :count
end
