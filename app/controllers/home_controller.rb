class HomeController < ApplicationController
  # GET /home
  def index
    render json: { message: "Welcome to the API!" }, status: :ok
  end
  
end
