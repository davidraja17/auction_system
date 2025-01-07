require 'rails_helper'
#require 'factory_bot_rails'

RSpec.describe Api::V1::UsersController, type: :request do
  # Define valid and invalid user attributes
  let(:valid_attributes) { { user: { name: 'John Doe', email: 'john.doe@example.com', password: 'password', password_confirmation: 'password' } } }
  let(:invalid_attributes) { { user: { name: '', email: 'john.doe@example.com', password: 'password', password_confirmation: 'password' } } }
  let(:user) { FactoryBot.create(:user, email: 'john.doe@example.com', password: 'password') }

  # Helper method to parse JSON response
  def json
    JSON.parse(response.body)
  end

  describe 'POST /api/v1/users/signup' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post '/api/v1/users/signup', params: valid_attributes
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json['message']).to eq('User created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        post '/api/v1/users/signup', params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq("Name can't be blank")
      end
    end
  end

  describe 'POST /api/v1/users/signin' do
    context 'with valid credentials' do
      it 'signs the user in and returns an authentication token' do
        post '/api/v1/users/signin', params: { user: { email: user.email, password: 'password' } }

        expect(response).to have_http_status(:ok)
        expect(json['message']).to eq('Signin successful')
        expect(json['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign the user in and returns an error' do
        post '/api/v1/users/signin', params: { user: { email: user.email, password: 'wrongpassword' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end
