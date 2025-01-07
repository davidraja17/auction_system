require 'rails_helper'

RSpec.describe Api::V1::BidsController, type: :controller do
  let(:user) { create(:user) }
  let(:auction) { create(:auction) }
  let(:valid_attributes) { { auction_id: auction.id, user_id: user.id, buyer_id: user.id, amount: 200 } }
  let(:invalid_attributes) { { auction_id: nil, user_id: nil, amount: -10 } }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new bid' do
        expect {
          post :create, params: { bid: valid_attributes }
        }.to change(Bid, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { bid: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new bid' do
        expect {
          post :create, params: { bid: invalid_attributes }
        }.to_not change(Bid, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { bid: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
