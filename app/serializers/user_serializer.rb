class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email_address, :role, :avatar_url

  def avatar_url
    object.avatar_image_url
  end
end
