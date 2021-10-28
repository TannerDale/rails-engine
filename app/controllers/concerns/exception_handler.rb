module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {
        message: 'your query could not be completed',
        error: { details: e.message }
      }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: {
        message: 'Missing Parameter',
        error: { details: e.message }
      }, status: :bad_request
    end

    rescue_from ActionController::BadRequest, ActiveRecord::RecordInvalid, Date::Error do |e|
      render json: {
        message: 'Invalid Parameters',
        error: { details: e.message }
      }, status: :bad_request
    end
  end
end
