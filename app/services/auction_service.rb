class AuctionService
  def initialize(auction)
    @auction = auction
  end

  def close_auction
    highest_bid = @auction.bids.order(amount: :desc).first
    if highest_bid && highest_bid.amount >= @auction.msp
      @auction.update(status: 'closed', winner_id: highest_bid.buyer.id)
      NotificationService.new.notify_winner(@auction)
    else
      @auction.update(status: 'unsold')
    end
  end
end
