class SerializableSearchResult < JSONAPI::Serializable::Resource
  type 'search_results'

  attribute :price do
    @object.money.amount
  end

  attribute :formatted_price do
    @object.money.format
  end

  attribute :currency do
    @object.money.currency.iso_code
  end

  has_one :product
end
