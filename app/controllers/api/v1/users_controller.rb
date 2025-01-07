module Api
  module V1
    class UsersController < ApplicationController
      # POST /api/v1/signup
      def signup
        user = User.new(user_params)

        if user.save
          render json: { message: 'User created successfully' }, status: :created
        else
          render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/signin
      def signin
        @user = User.find_by(email: signin_params[:email])
        
        if @user&.authenticate(signin_params[:password])
          render json: { message: "Signin successful", user: @user }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def signin_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
