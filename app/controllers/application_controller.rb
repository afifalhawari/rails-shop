class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login, :cart_item

  def cart_item
  	if session[:items].present?
	  	@cart_items = Product.where(id: session[:items]).all
	  	@cart_total = session[:items].map do |pid|
	      @cart_items.detect {|product| product.id == pid }.price
	    end.sum
	  end
  end
end
