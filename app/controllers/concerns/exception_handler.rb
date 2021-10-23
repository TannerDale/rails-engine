module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {
        message: 'your query could not be completed',
        errors: { details: e.message }
      }, status: :not_found
    end
  end
end
