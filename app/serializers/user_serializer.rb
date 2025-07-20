class UserSerializer
  include JSONAPI::Serializer
  
  attributes :id, :email, :created_at

  def initialize(user)
    @user = user
  end

  def serializable_hash
    {
      data: {
        id: @user.id,
        type: :user,
        attributes: {
          id: @user.id,
          email: @user.email,
          created_at: @user.created_at
        }
      }
    }
  end
end
