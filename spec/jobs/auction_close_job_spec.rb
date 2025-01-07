require 'rails_helper'

RSpec.describe AuctionCloseJob, type: :job do
  let(:auction) { create(:auction) }
  let(:user) { create(:user) }
  let(:bid) { create(:bid, auction: auction, buyer_id: user.id, amount: 500) }

  before do
    bid # Ensure a bid is present for the auction
  end

  it 'closes the auction and assigns the winner' do
    expect {
      described_class.perform_now(auction.id)
    }.to change { auction.reload.winner_id }.from(nil).to(user.id)
       .and change { auction.reload.final_price }.from(nil).to(500)
  end

  it 'does not update a non-existent auction' do
    expect {
      described_class.perform_now(-1)
    }.not_to raise_error
  end
end
