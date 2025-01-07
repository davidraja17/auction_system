module Api
  module V1
    class AutoBidsController < ApplicationController
      def create
        @auction = Auction.find(params[:auto_bid][:auction_id])
        @auto_bid = @auction.auto_bids.new(auto_bid_params)
        @auto_bid.buyer = User.find(@auction.user_id)

        if @auto_bid.save
          render json: @auto_bid, status: :created
        else
          render json: @auto_bid.errors, status: :unprocessable_entity
        end
      end

      private

      def auto_bid_params
        params.require(:auto_bid).permit(:max_amount, :auction_id)
      end
    end
  end
end
