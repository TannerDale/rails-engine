module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { errors: { details: e.message } }
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: 'your query could not be completed', errors: { details: e.message } }
    end
  end
end
