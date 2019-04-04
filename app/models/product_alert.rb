class ProductAlert < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantifier, :quantifier_type, :status, presence: true

  class Status
    include Ruby::Enum

    define :ACTIVE, 'active'
    define :CANCELED, 'canceled'
    define :SENT, 'sent'
  end

  class QuantifierType
    include Ruby::Enum

    define :PRICE, 'price'
    define :PERCENT, 'percent'
  end
end
