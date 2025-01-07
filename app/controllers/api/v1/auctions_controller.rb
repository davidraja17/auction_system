module Api
  module V1
    class AuctionsController < ApplicationController
      before_action :set_auction, only: [:show, :update, :destroy]


      # GET /api/v1/auctions
      def index
        @auctions = Auction.all
        render json: @auctions
      end

      # GET /api/v1/auctions/:id
      def show
        render json: @auction
      end

      # POST /api/v1/auctions
      def create
        @auction = Auction.new(auction_params)
        if @auction.save
          AuctionCloseJob.set(wait_until: @auction.ends_at).perform_later(@auction.id)
          render json: @auction, status: :created
        else
          render json: @auction.errors, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/auctions/:id
      def update
        if @auction.update(auction_params)
          render json: @auction
        else
          render json: @auction.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/auctions/:id
      def destroy
        @auction.destroy
        head :no_content
      end

      private

      def set_auction
        @auction = Auction.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Auction not found' }, status: :not_found
      end

      def auction_params
        params.require(:auction).permit(:title, :description, :starting_price, :msp, :duration, :ends_at, :user_id, :seller_id)
      end
    end
  end
end
