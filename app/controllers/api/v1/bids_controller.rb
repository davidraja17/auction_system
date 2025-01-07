module Api
  module V1
    class BidsController < ApplicationController
      def create
        @bid = Bid.new(bid_params)
        @bid_service = BidService.new(@bid)
        @bid_service.place_bid
        render json: @bid, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def bid_params
        params.require(:bid).permit(:auction_id, :amount, :buyer_id)
      end
    end
  end
end
