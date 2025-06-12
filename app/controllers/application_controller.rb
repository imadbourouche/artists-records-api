class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  def not_authorized
    render json: { error: "Not authorized" }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.find(payload[:user_id]) if payload[:user_id]
  end
  
  def payload
    @payload ||= authorize_access_request!
  end

  def authenticate_user!
    unless current_user
      not_authorized
    end
  end
  
  def authenticate_admin!
    unless current_user&.admin?
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    end
  end

  def not_authorized
    render json: { error: "Not authorized" }, status: :unauthorized
  end

end
