class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :buyer, class_name: 'User'

  validates :amount, numericality: { greater_than: 0 }

  def valid_bid?
    amount > auction.current_highest_bid
  end
end
