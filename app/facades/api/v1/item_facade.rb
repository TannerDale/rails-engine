class Api::V1::ItemFacade
  class << self
    def index_items(params)
      if params.key?(:merchant_id)
        Merchant.find(params[:merchant_id]).items
      else
        paginated_items(params)
      end
    end

    private

    def paginated_items(params)
      page = page_number(params[:page])
      page_size = per_page(params[:per_page])

      Item.all.offset(page * page_size).limit(page_size)
    end

    def per_page(size)
      size = size&.to_i || 20
      size.positive? ? size : 20
    end

    def page_number(page)
      page_num = page&.to_i || 1
      page_num.positive? ? page_num - 1 : 0
    end
  end
end
