class Api::V1::Revenue::RevenueController < ApplicationController
  before_action :validate_params, only: :unshipped

  def unshipped
    results = Merchant.ordered_by_packaged_revenue.limit(params[:quantity])
    render json: V1::UnshippedOrderSerializer.new(results)
  end

  def weekly
    weeks = Invoice.revenue_by_week
    render json: V1::WeeklyRevenueSerializer.new(weeks)
  end

  private

  def validate_params
    params[:quantity] ||= 10
    raise ActionController::BadRequest unless params[:quantity]&.to_i&.positive?
  end
end
