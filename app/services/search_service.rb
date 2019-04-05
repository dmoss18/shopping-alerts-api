class SearchService
  class Result
    attr_accessor :product, :money

    def initialize(product: nil, money: nil)
      @product = product
      @money = money
    end

    def id
      '' # For the serializable lib
    end
  end

  class << self
    def search(url)
      # TODO: Parse the url to detect which service to use
      AmazonService.search(url: url)
    end
  end
end
