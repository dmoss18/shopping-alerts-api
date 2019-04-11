require 'mechanize'

class AmazonService
  SELECTORS = [
    'span.a-color-price.offer-price',
    'tr.kindle-price',
    '#price_inside_buybox',
    '#priceblock_dealprice',
    '#priceblock_ourprice'
  ].freeze

  ASIN_REGEX = /\/(gp\/[product]+|dp)\/(?<asin>[a-zA-Z0-9_]*)/.freeze

  HOMEPAGE = 'https://www.amazon.com'.freeze

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
      url = url.split('?').first
      asin = parse_asin(url)
      product = find_or_create_product(asin: asin, url: url)
      parse_product_page(product)
    end

    def search_by_asin(asin)
      product = find_or_create_product(asin: asin)
      parse_product_page(product)
    end

    def parse_product_page(product)
      result = SearchService::Result.new(product: product)

      page = agent.get(product.url)
      money, selector = find_price(page, product)
      result.money = money

      # Hydrate product if needed
      params = {
        selector: selector,
        image_url: find_image_url(page),
        description: page.title  
      }
      product.assign_attributes(params)
      product.save! if product.changed?

      result
    end

    def find_or_create_product(asin:, url: nil)
      product = Product.find_or_initialize_by(vendor_identifier: asin)
      product.url = url if url
      return product if product.persisted?

      params = {
        vendor_identifier: asin,
        vendor: Product::Vendor::AMAZON,
        url: url || build_url(asin)
      }.compact

      product.update!(params)

      product
    end

    def selectors_for(product)
      return SELECTORS if product.nil? || product.selector.nil?
      # Put product_type selector at front of list so we try that first
      # If it fails (page has changed), go through the other selectors
      ([product.selector] | SELECTORS).compact.uniq
    end

    def parse_asin(url)
      match = ASIN_REGEX.match(url)
      return nil unless match
      match[:asin]
    end

    def build_url(asin) # TOOD: This isn't very reliable
      "https://www.amazon.com/dp/#{asin}"
    end

    def find_image_url(page)
      element = page.search('#landingImage').first
      return nil unless element
      element.attribute('src').try(:text)
    end

    def find_price(page, product)
      selectors_for(product).each do |selector|
        page.search(selector).each do |element|
          money = parse_price(element)
          return [money, selector] if money.present?
        end
      end

      nil
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

    def index_search(url)
      page = agent.get(url)
      parse_index_page(page)
    end

    def search_by_keyword(keyword)
      page = agent.get(HOMEPAGE)
      form = page.forms.first
      text_field = form.fields.find { |field| field.is_a? Mechanize::Form::Text }
      text_field.value = keyword
      index_page = agent.submit(form)
      parse_index_page(index_page)
    end

    def parse_index_page(page)
      page.search('div[data-asin]').each do |element|
        asin = element.attribute('data-asin').value
        image_url = element.search('img').first.attribute('src').value
        description = element.search('span.a-text-normal').first.text
        url_element = element.search('a').find do |link|
          link.attribute('href').value.include? asin # TODO: Sometimes the asin in the url is different
        end
        url = url_element.attribute('href').value if url_element

        # TODO: Find the product and update if it already exists
        Product.create(
          vendor_identifier: asin,
          image_url: image_url,
          url: url,
          description: description,
          vendor: Product::Vendor::AMAZON
        )
      end
    end
  end
end
