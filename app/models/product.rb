class Product < ApplicationRecord
  class Type
    include Ruby::Enum

    define :BOOK, 'book'
    define :KINDLE, 'kindle'
  end

  class Vendor
    include Ruby::Enum

    define :AMAZON, 'amazon'
    define :TARGET, 'target'
    define :WALMART, 'walmart'
  end

  validate :identifier_present?
  validates :vendor, :url, presence: true

  def identifier_present?
    # Require at least one of isbn or vendor_identifier
    if %w(isbn vendor_identifier).all? { |attr| self[attr].blank? }
      errors.add :base, "Product identifier required"
    end
  end
end
