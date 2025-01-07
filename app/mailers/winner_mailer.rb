class WinnerMailer < ApplicationMailer
  def notify_winner_email
    @user = params[:user]
    @auction = params[:auction]
    mail(to: @user.email, subject: "Congratulations! You've won the auction #{@auction.title}")
  end
end
