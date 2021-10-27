class ApplicationController < ActionController::API
  include ExceptionHandler
  include V1::Paginatable
end
