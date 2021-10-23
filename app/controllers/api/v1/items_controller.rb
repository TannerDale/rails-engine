class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.where(merchant_id: params[:merchant_id])
    render json: Api::V1::ItemSerializer.new(items).serializable_hash
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: Api::V1::ItemSerializer.new(item).serializable_hash, status: 201
    else
      render json: { message: 'Invalid attributes', errors: ['Invalid attributes'] }, status: 422
    end
  end

  private

  def item_params
    new_params = params.require(:item).permit(:name, :unit_price, :description, :merchant_id)
    new_params.merge({ unit_price: (new_params[:unit_price].to_f * 100) })
  end
end
