require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe 'associations' do
    it { should have_many(:auctions).dependent(:destroy) }
    it { should have_many(:bids).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'downcases email before saving' do
      user = User.new(name: 'John Doe', email: 'john.doe@example.com', password: 'password')
      user.save
      expect(user.email).to eq('john.doe@example.com')
    end
  end
end

