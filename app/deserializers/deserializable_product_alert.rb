class DeserializableProductAlert < JSONAPI::Deserializable::Resource
  attributes :original_price, :quantifier, :quantifier_type, :product_id, :user_id

  has_one :product
  has_one :user
end
