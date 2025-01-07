class AutoBid < ApplicationRecord
  belongs_to :buyer, class_name: 'User'
  belongs_to :auction

  validates :buyer_id, :max_amount, :auction_id, presence: true
  validates :max_amount, numericality: { greater_than: 0 }
  validate :max_amount_is_higher_than_current_bid

  private

  # Validation to ensure max_amount is higher than the current highest bid
  def max_amount_is_higher_than_current_bid
    if auction.present? && auction.current_highest_bid && max_amount <= auction.current_highest_bid
      errors.add(:max_amount, "must be greater than the current highest bid")
    end
  end
end
