class Api::V1::ItemSearchController < ApplicationController
  before_action :validate_params

  def find
    item = Api::V1::ItemSearchFacade.search(params, :one)
    render json: Api::V1::ItemSerializer.new(item)
  end

  def find_all
    items = Api::V1::ItemSearchFacade.search(params, :all)
    render json: Api::V1::ItemSerializer.new(items)
  end

  private

  def validate_params
    raise ActionController::BadRequest if empty_params? || no_params?
  end

  def no_params?
    !(params[:name] || params[:min_price] || params[:max_price])
  end

  def empty_params?
    params[:name]&.empty? || params[:max_price]&.empty? || params[:min_price]&.empty?
  end
end
