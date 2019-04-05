class ProductsController < ApplicationController
  deserializable_resource :product, only: [:create, :update]
  
  # TODO: Delete the index endpoint in prod
  def index
    success Product.all
  end

  def show
    success Product.find(params[:id])
  end

  def create
    success Product.create!(product_params)
  end

  def update
    product = Product.find(product_params[:id])
    success product.update!(product_params)
  end

  def search
    result = SearchService.search(params[:url])
    success result,
            include: [:product],
            class: {
              :"SearchService::Result" => SerializableSearchResult,
              :"Product" => SerializableProduct
            }
  end

  private

  def product_params
    params.require(:product).permit(:vendor, :isbn, :vendor_identifier, :description, :url, :image_url, :product_type)
  end
end
