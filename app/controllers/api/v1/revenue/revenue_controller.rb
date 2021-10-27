class Api::V1::Revenue::RevenueController < ApplicationController
  before_action :validate_params

  def unshipped
    results = Merchant.ordered_by_packaged_revenue.limit(params[:quantity])
    render json: V1::UnshippedOrderSerializer.new(results)
  end

  private

  def validate_params
    params[:quantity] ||= 10
    raise ActionController::BadRequest unless params[:quantity]&.to_i&.positive?
  end
end
