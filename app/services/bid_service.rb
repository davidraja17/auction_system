class BidService
  def initialize(bid)
    @bid = bid
  end

  def place_bid
    if @bid.valid_bid?
      ActiveRecord::Base.transaction do
        # Process AutoBids
        AutoBid.where(auction: @bid.auction).find_each do |auto_bid|
          next if auto_bid.max_amount <= @bid.amount

          new_amount = [@bid.amount + 1, auto_bid.max_amount].min
          auto_bid.auction.bids.create!(amount: new_amount, buyer: auto_bid.buyer)
        end

        @bid.save!
      end
    else
      raise StandardError, 'Invalid Bid'
    end
  end
end
