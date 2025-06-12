class RefreshController < ApplicationController
  include JWTSessions::RailsAuthorization

  before_action :authorize_refresh_by_access_request!

  # POST /refresh
  def create
    session = JWTSessions::Session.new(
      refresh_by_access_allowed: true,
      payload: { user_id: current_user[:user_id] }
    )

    tokens = session.refresh_by_access_payload

    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?,
                        same_site: :strict)

    response.set_cookie(JWTSessions.refresh_cookie,
                        value: tokens[:refresh],
                        httponly: true,
                        secure: Rails.env.production?,
                        same_site: :strict)

    render json: { access: tokens[:access] }
  end
end
