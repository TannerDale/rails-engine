class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Api::V1::MerchantFacade.index_merchants(params)
    render json: Api::V1::MerchantSerializer.new(merchants).serializable_hash
  end

  def show; end
end
