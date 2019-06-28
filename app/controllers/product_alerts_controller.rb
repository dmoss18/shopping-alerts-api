class ProductAlertsController < ApplicationController
  deserializable_resource :product_alert, only: [:create, :update]

  def index
    success ProductAlert.where(user_id: current_user.id), include: [:product]
  end

  def show
    success ProductAlert.find_by!(params[:id], user_id: current_user.id), include: [:product]
  end

  def create
    product_alert = ProductAlert.create!(alert_params.merge(user_id: current_user.id))
    # TODO: Fire off a worker to start querying the price
    success product_alert, include: [:product]
  end

  private

  def alert_params
    params.require(:product_alert).permit(:original_price, :quantifier, :quantifier_type, :product_id)
  end
end
