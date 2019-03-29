class ProductAlert < ApplicationRecord
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
