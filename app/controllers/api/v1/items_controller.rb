class Api::V1::ItemsController < ApplicationController
  def index
    items = Merchant.find(params[:merchant_id]).items
    render json: Api::V1::ItemSerializer.new(items).serializable_hash
  end

  def create
    item = Item.create!(item_params)
    render json: Api::V1::ItemSerializer.new(item).serializable_hash
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    render json: Api::V1::ItemSerializer.new(item).serializable_hash
  end

  private

  def item_params
    new_params = params.require(:item).permit(:name, :unit_price, :description, :merchant_id)
    new_params.merge({ unit_price: (new_params[:unit_price].to_f * 100) })
  end
end
