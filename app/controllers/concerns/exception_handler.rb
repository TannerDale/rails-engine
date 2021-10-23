module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {
        message: 'Invalide Parameters',
        errors: { details: e.message }
      }, status: 400
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {
        message: 'your query could not be completed',
        errors: { details: e.message }
      }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: {
        message: 'Missing Parameter',
        errors: { details: e.message }
      }, status: 400
    end
  end
end
