class Api::V1::ItemSearchController < ApplicationController
  def find
    raise ActionController::BadRequest if empty_search_params?

    item = Api::V1::ItemSearchFacade.search(params, :one)
    render json: Api::V1::ItemSerializer.new(item).serializable_hash
  end

  def find_all
    raise ActionController::BadRequest if empty_search_params?

    item = Api::V1::ItemSearchFacade.search(params, :all)
    render json: Api::V1::ItemSerializer.new(item).serializable_hash
  end

  private

  def empty_search_params?
    params[:name]&.empty? || params[:max_price]&.empty? || params[:min_price]&.empty?
  end
end
