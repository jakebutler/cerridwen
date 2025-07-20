class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Devise::Controllers::Helpers
  
  # Enable sessions for Devise authentication
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Define authenticate_user! method for API authentication
  def authenticate_user!
    unless user_signed_in?
      render json: { error: 'Authentication required' }, status: :unauthorized
    end
  end
  
  # Define Devise helper methods for API mode
  def user_signed_in?
    current_user.present?
  end
  
  def current_user
    @current_user ||= begin
      user_data = warden.authenticate(scope: :user)
      if user_data.is_a?(Hash)
        # If warden returns a hash, find the user by ID
        User.find_by(id: user_data['id'])
      else
        user_data
      end
    end
  end

  def health
    render json: { status: 'ok', timestamp: Time.current }
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
