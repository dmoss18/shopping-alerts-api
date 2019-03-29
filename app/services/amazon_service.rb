require 'mechanize'

class AmazonService
  SELECTORS = {
    book: 'span.a-color-price.offer-price',
    kindle: 'tr.kindle-price',
    default: '//*[(@id = "price_inside_buybox")]'
  }.freeze

  ASIN_REGEX = /\/dp\/(?<asin>[a-zA-Z0-9_]*)/.freeze

  class << self
    def agent
      @agent ||= Mechanize.new
    end

    def find_price_by(url: nil, asin: nil)
      if url
        return find_price_by_url(url)
      else
        return find_price_by_asin(asin)
      end
    end

    def find_price_by_url(url)
      asin = parse_asin(url)
      find_price_by_asin(asin)
    end

    def find_price_by_asin(asin)
      url =  "https://www.amazon.com/dp/#{asin}"
      product = Product.find_by(vendor_identifier: asin)
      selectors = selectors_for(product)

      page = agent.get(url)
      selectors.each do |selector|
        page.search(selector).each do |element|
          money = parse_price(element)
          return money if money.present?
        end
      end

      nil
    end

    def selectors_for(product)
      return SELECTORS.values if product.nil? || product.product_type.nil?
      selector = SELECTORS[product.product_type]
      selector.present? ? [selector] : SELECTORS.values
    end

    def parse_asin(url)
      match = ASIN_REGEX.match(url)
      return nil unless match
      match[:asin]
    end

    def parse_price(element)
      if element.text?
        money = Monetize.parse(element.text)
        return money if money.amount > 0
      else
        element.children.each do |child|
          money = parse_price(child)
          return money if money.present?
        end
      end

      nil
    end
  end
end
