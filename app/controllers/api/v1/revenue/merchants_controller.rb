class Api::V1::Revenue::MerchantsController < ApplicationController
  def revenue
    raise ActionController::BadRequest unless valid_params?

    merchants = Merchant.ordered_by_revenue.limit(params[:quantity])
    render json: Api::V1::MerchantNameRevenueSerializer.new(merchants).serializable_hash
  end

  private

  def valid_params?
    params[:quantity]&.to_i&.positive?
  end
end
