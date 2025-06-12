class SignupController < ApplicationController
  # POST /signup
  def create
    user = User.new(sign_up_params)

    if user.save
      payload = { user_id: user.id }
      token = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true).login
      response.set_cookie(JWTSessions.access_cookie,
                          value: token[:access],
                          httponly: true, 
                          secure: Rails.env.production?,
                          same_site: :strict)
      response.set_cookie(JWTSessions.refresh_cookie,
                          value: token[:refresh],
                          httponly: true,
                          secure: Rails.env.production?,
                          same_site: :strict)
      render json: { message: "Sign up successful", user_id: user.id }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
