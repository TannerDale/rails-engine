class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = paginate(Merchant.all, params)
    render json: V1::MerchantSerializer.new(merchants)
  end

  def show
    render json: V1::MerchantSerializer.new(find_merchant)
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
