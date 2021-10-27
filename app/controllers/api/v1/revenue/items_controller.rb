class Api::V1::Revenue::ItemsController < ApplicationController
  def revenue
    raise ActionController::BadRequest if invalid_params?

    items = Item.ordered_by_revenue.limit(params[:quantity] || 10)
    render json: V1::ItemRevenueSerializer.new(items)
  end

  private

  def invalid_params?
    params[:quantity] && (invalid_quantity? || empty_quantity?)
  end

  def invalid_quantity?
    !params[:quantity]&.to_i&.positive?
  end

  def empty_quantity?
    params[:quantity]&.empty?
  end
end
