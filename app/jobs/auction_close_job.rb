class AuctionCloseJob < ApplicationJob
  queue_as :default

  def perform(auction_id)
    auction = Auction.find_by(id: auction_id)

    # Ensure the auction exists and is still active
    if auction && auction.active?
      auction.update!(status: 'closed')
      
      # Determine the winner
      highest_bid = auction.bids.order(amount: :desc).first
      if highest_bid
        auction.update!(winner_id: highest_bid.buyer_id, final_price: highest_bid.amount)
        notify_winner(highest_bid.buyer_id, auction)
      else
        notify_no_bids(auction)
      end
    end
  end

  private

  def notify_winner(winner, auction)
    # Example notification logic for the winner
    WinnerMailer.with(user: winner, auction: auction).notify_winner_email.deliver_later
  end

  def notify_no_bids(auction)
    # Example notification logic if there are no bids
    AdminMailer.with(auction: auction).notify_no_bids_email.deliver_later
  end
end
