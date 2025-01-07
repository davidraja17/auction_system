class AdminMailer < ApplicationMailer
  def notify_no_bids_email
    @auction = params[:auction]
    mail(to: 'admin@example.com', subject: "No Bids for Auction #{@auction.title}")
  end
end
