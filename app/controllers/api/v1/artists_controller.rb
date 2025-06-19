module Api
  module V1
    class ArtistsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_artist, only: %i[ show update destroy ]

      # GET /artists
      def index
        @artists = Artist.all
        @artists = @artists.page(params[:page]).per(params[:page_size] || 10)

        render json: {
          artists: @artists,
          meta: {
            current_page: @artists.current_page,
            total_pages: @artists.total_pages,
            total_count: @artists.total_count
          }
        }
      end

      # GET /artists/1
      def show
        render json: @artist
      end

      # POST /artists
      def create
        @artist = Artist.new(artist_params)

        if @artist.save
          render json: @artist, status: :created
        else
          render json: @artist.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /artists/1
      def update
        if @artist.update(artist_params)
          render json: @artist
        else
          render json: @artist.errors, status: :unprocessable_entity
        end
      end

      # DELETE /artists/1
      def destroy
        @artist.destroy!
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_artist
        @artist = Artist.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def artist_params
        params.expect(artist: [ :name, :user_id ])
      end
    end
  end
end
