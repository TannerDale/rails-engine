class V1::WeeklyRevenueSerializer
  include JSONAPI::Serializer

  attribute :revenue

  attribute :week do |obj|
    obj.week.strftime('%Y-%m-%d')
  end
end
