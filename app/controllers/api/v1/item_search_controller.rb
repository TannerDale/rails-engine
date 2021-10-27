class Api::V1::ItemSearchController < ApplicationController
  before_action :validate_params

  def find
    item = V1::ItemSearchFacade.search(params, :one)
    result = item ? V1::ItemSerializer.new(item) : { data: {} }

    render json: result
  end

  def find_all
    items = V1::ItemSearchFacade.search(params, :all)
    render json: V1::ItemSerializer.new(items)
  end

  private

  def validate_params
    raise ActionController::BadRequest if invalid_params?
  end

  def invalid_params?
    empty_params? || name_and_price? || invalid_prices? || !present_params?
  end

  def present_params?
    params[:name] || params[:max_price] || params[:min_price]
  end

  def name_and_price?
    params[:name] && (params[:min_price] || params[:max_price])
  end

  def empty_params?
    params[:name]&.empty? || params[:max_price]&.empty? || params[:min_price]&.empty?
  end

  def invalid_prices?
    min_greater_than_max? || invalid_min_or_max?
  end

  def invalid_min_or_max?
    params[:max_price].to_i.negative? || params[:min_price].to_i.negative?
  end

  def min_greater_than_max?
    params[:min_price].to_i > params[:max_price].to_i if params[:min_price] && params[:max_price]
  end
end
