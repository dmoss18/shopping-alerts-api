class ProductAlertsController < ApplicationController
  def index
    render jsonapi: ProductAlert.all, include: [:product]
  end

  def show
    # TODO: Create a 'current_user' helper and make sure we are finding by that user as well as product id
    render jsonapi: ProductAlert.find(params[:id]), include: [:product]
  end
end
