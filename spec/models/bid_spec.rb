require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe 'validations' do
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:auction) }
  end

  describe 'custom validations' do
    it 'is invalid if amount is less than current highest bid' do
      auction = create(:auction, starting_price: 100)
      create(:bid, auction: auction, amount: 150)
      bid = Bid.new(auction: auction, amount: 120)

      expect(bid).to_not be_valid
    end
  end
end

