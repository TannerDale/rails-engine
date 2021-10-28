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
        Item.find_by_name(params[:name])
      else
        Item.find_in_range(params[:min_price], params[:max_price])
      end
    end
  end
end
