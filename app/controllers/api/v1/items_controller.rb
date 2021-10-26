class Api::V1::ItemsController < ApplicationController
  before_action :validate_merchant, only: :update

  def index
    items = Api::V1::ItemFacade.index_items(params)
    render json: Api::V1::ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: Api::V1::ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: Api::V1::ItemSerializer.new(item), status: 201
  end

  def update
    item = Item.find(params[:id])

    item.update(item_params)
    render json: Api::V1::ItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :unit_price, :description, :merchant_id)
  end

  def validate_merchant
    raise ActionController::BadRequest if params[:item]&.key?(:merchant_id) &&
                                          !Merchant.find_by(id: params[:item][:merchant_id])
  end
end
