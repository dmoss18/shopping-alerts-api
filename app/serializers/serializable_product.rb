class SerializableProduct < JSONAPI::Serializable::Resource
  type 'product'
  attributes :id, :vendor, :isbn, :vendor_identifier, :description, :image_url, :product_type
end
