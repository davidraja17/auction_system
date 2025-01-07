class Notification < ApplicationRecord
	belongs_to :user

	validates :user_id, :message, presence: true
end
