class Auction < ApplicationRecord
  enum status: { active: 0, closed: 1 }

  has_many :bids, dependent: :destroy
  has_many :auto_bids, dependent: :destroy
  belongs_to :winner, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :seller, class_name: 'User', foreign_key: 'user_id'

  validates :title, :description, :starting_price, :msp, :duration, :ends_at, presence: true
  validate :duration_is_positive

  def active?
    Time.current < ends_at
  end

  def current_highest_bid
    bids.maximum(:amount) || starting_price
  end

  private

  def duration_is_positive
  	return if duration.nil? 
    errors.add(:duration, 'must be greater than zero') if duration <= 0
  end
end
