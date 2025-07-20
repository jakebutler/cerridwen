class ApplicationController < ActionController::API
  # before_action :authenticate_user!, except: [:health] # Temporarily disabled for Active Agent testing
  before_action :configure_permitted_parameters, if: :devise_controller?

  def health
    render json: { status: 'ok', timestamp: Time.current }
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
