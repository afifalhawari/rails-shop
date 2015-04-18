class ProductsController < ApplicationController

	skip_before_filter :require_login, only: [:index, :show]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
  end

  def create
  	@product = Product.new(product_params)

	if @product.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
  	@product = Product.find(params[:id])
  	@product.destroy

  	redirect_to root_path
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :image, :description)
  end
  def not_authenticated
  	redirect_to new_user_session_path, alert: "Please login first"
	end

end
