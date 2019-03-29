class ProductSerializer < ActiveModel::Serializer
  attributes :id, :vendor, :isbn, :vendor_identifier, :description, :image_url, :product_type
end
