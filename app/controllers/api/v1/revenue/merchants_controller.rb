class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    raise ActionController::BadRequest unless valid_quantity?

    merchants = Merchant.ordered_by_sold_revenue.limit(params[:quantity])
    render json: V1::MerchantNameRevenueSerializer.new(merchants).serializable_hash
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: V1::MerchantRevenueSerializer.new(merchant)
  end

  private

  def valid_quantity?
    params[:quantity]&.to_i&.positive?
  end
end
