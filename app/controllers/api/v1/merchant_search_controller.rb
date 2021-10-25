class Api::V1::MerchantSearchController < ApplicationController
  before_action :validate_params, except: :items_sold

  def find
    merchant = Merchant.find_by_name(params[:name]).first
    if merchant
      render json: Api::V1::MerchantSerializer.new(merchant)
    else
      render json: no_merchant_found, status: 400
    end
  end

  def find_all
    merchants = Merchant.find_by_name(params[:name])
    render json: Api::V1::MerchantSerializer.new(merchants)
  end

  def items_sold
    merchants = Merchant.ordered_by_items_sold.limit(params[:quantity] || 5)
    render json: Api::V1::ItemsSoldSerializer.new(merchants)
  end

  private

  def validate_params
    raise ActionController::BadRequest if invalid_params?
  end

  def invalid_params?
    params[:name].nil? || params[:name].empty?
  end

  def no_merchant_found
    {
      message: 'No merchant found',
      data: { errors: "No merchant matching #{params[:name]} found" }
    }
  end
end
