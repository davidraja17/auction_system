require 'rails_helper'

RSpec.describe Api::V1::AuctionsController, type: :controller do
  let(:user) { create(:user) }
  let(:auction) { create(:auction, seller: user, msp: 100.0) }
  let(:valid_attributes) {
  {
    title: "Sample Auction",
    description: "This is a detailed description of the auction",
    starting_price: 100.0,
    msp: 150.0,
    duration: 7,
    ends_at: 1.day.from_now,
    user_id: user.id,
    seller_id: user.id
  }
 }
  let(:invalid_attributes) { { title: '', starting_price: -10, ends_at: 1.day.ago, user_id: nil, duration: 1 } }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'assigns all auctions to @auctions' do
      auction
      get :index
      expect(assigns(:auctions)).to eq([auction])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: auction.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a not found response if auction does not exist' do
      get :show, params: { id: 'invalid_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new auction' do
        expect {
          post :create, params: { auction: valid_attributes }
        }.to change(Auction, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { auction: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      # it 'does not create a new auction' do
      #   expect {
      #     post :create, params: { auction: invalid_attributes }
      #   }.to_not change(Auction, :count)
      # end

      it 'returns an unprocessable entity status' do
        post :create, params: { auction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid attributes' do
      it 'updates the requested auction' do
        patch :update, params: { id: auction.id, auction: { title: 'Updated Title' } }
        auction.reload
        expect(auction.title).to eq('Updated Title')
      end

      it 'returns a successful response' do
        patch :update, params: { id: auction.id, auction: { title: 'Updated Title' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the requested auction' do
        patch :update, params: { id: auction.id, auction: { title: '' } }
        auction.reload
        expect(auction.title).to_not eq('')
      end

      it 'returns an unprocessable entity status' do
        patch :update, params: { id: auction.id, auction: { title: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the requested auction' do
      auction
      expect {
        delete :destroy, params: { id: auction.id }
      }.to change(Auction, :count).by(-1)
    end

    it 'returns a no content status' do
      delete :destroy, params: { id: auction.id }
      expect(response).to have_http_status(:no_content)
    end

    it 'returns a not found response for an invalid id' do
      delete :destroy, params: { id: 'invalid_id' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
