class SerializableProduct < JSONAPI::Serializable::Resource
  type 'products'
  attributes :id, :vendor, :isbn, :vendor_identifier, :description, :image_url
end
