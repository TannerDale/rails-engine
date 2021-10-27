class Api::V1::ItemsController < ApplicationController
  before_action :validate_merchant, only: :update

  def index
    render json: V1::ItemSerializer.new(index_items)
  end

  def show
    item = Item.find(params[:id])
    render json: V1::ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: V1::ItemSerializer.new(item), status: 201
  end

  def update
    item = Item.find(params[:id])

    item.update(item_params)
    render json: V1::ItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  private

  def index_items
    if params[:merchant_id]
      Merchant.find(params[:merchant_id]).items
    else
      paginate(Item.all, params)
    end
  end

  def item_params
    params.require(:item).permit(:name, :unit_price, :description, :merchant_id)
  end

  def validate_merchant
    raise ActionController::BadRequest if params[:item]&.key?(:merchant_id) &&
                                          !Merchant.find_by(id: params[:item][:merchant_id])
  end
end
