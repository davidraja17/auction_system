require 'rails_helper'

RSpec.describe Auction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:starting_price) }
    it { should validate_presence_of(:ends_at) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:bids).dependent(:destroy) }
    it { should have_many(:auto_bids).dependent(:destroy) }
  end

  describe 'custom validations' do
    it 'is invalid if end_time is in the past' do
      auction = Auction.new(title: 'Test Auction', starting_price: 100, ends_at: 1.day.ago)
      expect(auction).to_not be_valid
    end
  end
end
