require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end

