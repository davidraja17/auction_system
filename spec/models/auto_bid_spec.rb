require 'rails_helper'

RSpec.describe AutoBid, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:buyer_id) }
    it { should validate_presence_of(:auction_id) }
    it { should validate_presence_of(:max_amount) }
  end

  describe 'associations' do
    it { should belong_to(:auction) }
  end

  describe 'custom validations' do
    it 'is invalid if max_bid is less than starting price' do
      auction = create(:auction, starting_price: 100)
      auto_bid = AutoBid.new(buyer_id: create(:user), auction: auction, max_amount: 50)
      expect(auto_bid).to_not be_valid
    end
  end
end

