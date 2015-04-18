class CheckoutsController < ApplicationController

  skip_before_filter :require_login, except: [:pay_vtweb, :charge_vt_direct]
  #skip_before_action :verify_authenticity_token

  def add_item
    product = Product.find(params[:id])
    session[:items] ||= []
    session[:items] << product.id

    flash[:notice] = "Item added"
    redirect_to request.referer || root_path
  end

  def pay_vtweb
    load_cart_info

    @result = Veritrans.charge(
      payment_type: "VTWEB",
      transaction_details: {
        order_id: "VERITRANS-ORDERID",
        gross_amount: @total
      }
    )
    puts @result.to_json
    if @result.redirect_url.present?
      session.delete(:items)
      redirect_to @result.redirect_url
    else
      redirect_to root_path
    end
  end

  def pay_vtdirect
    load_cart_info
    @order_id = Time.now-rand
    render 'payment'
  end

  def charge_vt_direct
    load_cart_info
    create_item_details

    @result = Veritrans.charge(
      payment_type: "credit_card",
      credit_card: { token_id: params[:token_id] },
      transaction_details: {
        order_id: params[:order_id],
        gross_amount: params[:gross_amount]
      },
      customer_details: {
        email: current_user.email
      },
      item_details: @item_details
    )
    if @result.success?
      puts "Success"
      session.delete(:items)
      redirect_to root_path, notice: "success"
    else
      flash[:notice] = @result.message
      redirect_to root_path, notice: "payment failed"
    end
  end

  def index
    load_cart_info
  end

  def destroy
    session[:items].delete(params[:id].to_i)
    if session[:items].present?
      @cart_items = Product.where(id: session[:items]).all
      @cart_total = session[:items].map do |pid|
        @cart_items.detect {|product| product.id == pid }.price
      end.sum
    end
    render partial: 'cart', layout: false
  end

  private
  def load_cart_info
    @products = Product.where(id: session[:items]).all
    @total = session[:items].map do |pid|
      @products.detect {|product| product.id == pid }.price
    end.sum
  end

  def create_item_details
    @item_details ||= []
    @products.each do |p|
      item = {
        id: p.id,
        price: p.price,
        quantity: session[:items].count(p.id),
        name: p.name
      }
      @item_details << item
    end
  end

  def not_authenticated
    redirect_to new_user_session_path, alert: "Please login first"
  end
end