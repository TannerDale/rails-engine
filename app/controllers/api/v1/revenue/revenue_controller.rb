class Api::V1::Revenue::RevenueController < ApplicationController
  before_action :validate_quantity, only: :unshipped

  def unshipped
    results = Merchant.ordered_by_packaged_revenue.limit(params[:quantity])
    render json: V1::UnshippedOrderSerializer.new(results)
  end

  def weekly
    weeks = Invoice.revenue_by_week
    render json: V1::WeeklyRevenueSerializer.new(weeks)
  end

  def range
    validate_date_params

    start, stop = validate_dates
    revenue = Invoice.revenue_range(start, stop + 1)[0]
    render json: V1::RevenueSerializer.new(revenue)
  end

  private

  def validate_dates
    start = Date.parse(params[:start])
    stop = Date.parse(params[:end])

    raise ActionController::BadRequest unless start < stop

    [start, stop]
  end

  def validate_date_params
    raise ActionController::BadRequest unless present_date_params?
  end

  def present_date_params?
    params[:start].present? && params[:end].present?
  end

  def validate_quantity
    params[:quantity] ||= 10
    raise ActionController::BadRequest unless params[:quantity]&.to_i&.positive?
  end
end
