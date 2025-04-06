class StocksController < ApplicationController
  def search
    @user = current_user
    @tracked_stocks = current_user.stocks if user_signed_in?
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      @stocks = [] if @stocks.nil?
      if @stock
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("result", partial: "users/result", locals: { stocks: @stocks })
          end
          format.html { render 'users/my_portfolio' }
        end
      else
      flash.now[:alert] = "Please enter a valid symbol to search"
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("messages", partial: "layouts/messages") }
          format.html { render 'users/my_portfolio' }
        end
      end    
    else
      flash[:alert] = "Please enter a symbol to search"
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("messages", partial: "layouts/messages") }
        format.html { render 'users/my_portfolio' }
      end
    end
  end
end