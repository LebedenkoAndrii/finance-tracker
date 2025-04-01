class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock_data = Stock.new_lookup(params[:ticker])
      if stock_data
        stock = Stock.new(ticker: stock_data[:ticker], name: stock_data[:name], last_price: stock_data[:price])
        stock.save
      else
        flash[:alert] = "Could not fetch stock data for #{params[:ticker]}"
        redirect_to my_portfolio_path and return
      end
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to my_portfolio_path
  end
end
