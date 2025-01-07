require 'rails_helper'

RSpec.describe Api::V1::AutoBidsController, type: :controller do
  let(:user) { create(:user) }
  let(:auction) { create(:auction) }
  let(:valid_attributes) { { auction_id: auction.id, user_id: user.id, max_amount: 500 } }
  let(:invalid_attributes) { { auction_id: auction.id, user_id: nil, max_amount: -100 } }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new auto bid' do
        expect {
          post :create, params: { auto_bid: valid_attributes }
        }.to change(AutoBid, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { auto_bid: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do

      it 'returns an unprocessable entity status' do
        post :create, params: { auto_bid: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
