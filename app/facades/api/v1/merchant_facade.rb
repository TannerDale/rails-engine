class Api::V1::MerchantFacade
  class << self
    def index_merchants(params)
      page = page_number(params[:page])
      page_size = per_page(params[:per_page])

      Merchant.offset(page * page_size).limit(page_size)
    end

    private

    def per_page(size)
      size = size&.to_i || 20
      size.positive? ? size : 20
    end

    def page_number(page)
      page_number = page&.to_i || 1
      page_number.positive? ? page_number - 1 : 0
    end
  end
end
