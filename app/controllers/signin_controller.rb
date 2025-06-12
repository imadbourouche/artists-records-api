class SigninController < ApplicationController
  # POST /login
  def create
    if sign_in_params.values.any?(&:blank?)
      return render json: { error: "Missing credentials" }, status: :bad_request
    end

    user = User.find_by(email: sign_in_params[:email])

    if user&.authenticate(sign_in_params[:password])
      payload = { user_id: user.id }

      token = JWTSessions::Session.new(
        payload: payload,
        refresh_by_access_allowed: true
      ).login

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

      render json: { message: "Sign in successful", user_id: user.id }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # DELETE /signout
  def destroy
    response.delete_cookie(JWTSessions.access_cookie)
    response.delete_cookie(JWTSessions.refresh_cookie)
    render json: { message: "Sign out successful" }, status: :ok
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
