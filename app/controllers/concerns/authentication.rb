module Authentication
  extend ActiveSupport::Concern

  # This will decode the JWT token to get user information
  def current_user
    decoded_token = decode_token(request.headers['Authorization'])
    @current_user ||= User.find_by(id: decoded_token[:user_id]) if decoded_token
  rescue
    nil
  end

  # This method will decode the token
  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
  end

  # This method will check if the user is authenticated
  def authenticate_user!
    render json: { error: 'Not Authenticated' }, status: :unauthorized unless current_user
  end
end
