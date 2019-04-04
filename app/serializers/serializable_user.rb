class SerializableUser < JSONAPI::Serializable::Resource
  type 'user'

  attributes :id, :email, :username
end
