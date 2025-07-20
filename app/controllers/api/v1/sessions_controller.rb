class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    render json: {
      status: { code: 200, message: 'Logged out successfully.' }
    }
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }
  end

  def respond_to_on_destroy
    render json: {
      status: { code: 200, message: 'Logged out successfully.' }
    }
  end
end
