class User < ApplicationRecord
  has_secure_password

  has_many :auctions, foreign_key: :seller_id, dependent: :destroy
  has_many :bids, foreign_key: :buyer_id, dependent: :destroy
  has_many :auto_bids, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
