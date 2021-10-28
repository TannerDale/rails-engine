class Api::V1::Revenue::ItemsController < ApplicationController
  def revenue
    raise ActionController::BadRequest unless valid_quantity?

    items = Item.ordered_by_revenue.limit(params[:quantity] || 10)
    render json: V1::ItemRevenueSerializer.new(items)
  end

  private

  def valid_quantity?
    params[:quantity].nil? || params[:quantity].to_i.positive?
  end
end
