class ProductsController < ApplicationController
  # TODO: Delete the index endpoint in prod
  def index
    render json: Product.all
  end

  def show
    render json: Product.find(params[:id])
  end
end
