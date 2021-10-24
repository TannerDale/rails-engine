class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Api::V1::MerchantFacade.index_merchants(params)
    render json: Api::V1::MerchantSerializer.new(merchants).serializable_hash
  end

  def show
    render json: Api::V1::MerchantSerializer.new(find_merchant).serializable_hash
  end

  private

  def find_merchant
    if params[:item_id]
      Item.find(params[:item_id]).merchant
    else
      Merchant.find(params[:id])
    end
  end
end
