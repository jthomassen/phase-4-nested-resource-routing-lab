class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item, include: :user
    else
      render json: { error: "Item not found" }, status: :not_found
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, include: :user, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price, :user)
  end

end
