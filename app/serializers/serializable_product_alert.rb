class SerializableProductAlert < JSONAPI::Serializable::Resource
  type 'product_alerts'

  attributes :id, :product_id, :user_id

  belongs_to :product
  belongs_to :user
end
