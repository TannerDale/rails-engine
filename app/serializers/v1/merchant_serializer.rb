class V1::MerchantSerializer
  include JSONAPI::Serializer

  attribute :name

  def self.not_found(name)
    {
      message: 'No merchant found',
      data: { errors: "No merchant matching #{name} found" }
    }
  end
end
