class V1::ItemSearchFacade
  class << self
    def search(params, amount)
      results = {
        all: -> { find_items(params) },
        one: -> { find_items(params).first }
      }
      results[amount].call
    end

    private

    def find_items(params)
      if params[:name]
        name_search(params[:name])
      else
        price_search(params)
      end
    end

    def name_search(name)
      Item.find_by_name(name)
    end

    def price_search(params)
      if params[:min_price] && params[:max_price]
        Item.find_in_range(params[:min_price], params[:max_price])
      elsif params[:min_price]
        Item.above_price(params[:min_price])
      else
        Item.below_price(params[:max_price])
      end
    end
  end
end
