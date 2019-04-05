require 'mechanize'

class AmazonService
  SELECTORS = {
    book: 'span.a-color-price.offer-price',
    kindle: 'tr.kindle-price',
    default: '//*[(@id = "price_inside_buybox")]'
  }.freeze

  ASIN_REGEX = /\/(gp\/[product]+|dp)\/(?<asin>[a-zA-Z0-9_]*)/.freeze

  class << self
    def agent
      @agent ||= Mechanize.new
    end

    def search(url: nil, identifier: nil)
      if url
        return search_by_url(url)
      else
        return search_by_asin(identifier)
      end
    end

    def search_by_url(url)
      asin = parse_asin(url)
      search_by_asin(asin)
    end

    def search_by_asin(asin)
      url =  build_url(asin)
      product = find_or_create_product(asin: asin)
      selectors = selectors_for(product)
      result = SearchService::Result.new(product: product)

      page = agent.get(url)
      selectors.each do |selector|
        page.search(selector).each do |element|
          money = parse_price(element)
          if money.present?
            product.update(product_type: SELECTORS.key(selector))
            result.money = money
            return result
          end
        end
      end

      nil
    end

    def find_or_create_product(asin:, url: nil, product_type: nil, description: nil)
      product = Product.find_or_initialize_by(vendor_identifier: asin)
      return product if product.persisted?

      params = {
        vendor_identifier: asin,
        vendor: Product::Vendor::AMAZON,
        url: url || build_url(asin),
        description: description,
        product_type: product_type
      }.compact

      product.update!(params)

      product
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

    def build_url(asin)
      "https://www.amazon.com/dp/#{asin}"
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
