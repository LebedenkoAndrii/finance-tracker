class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      respond_to do |format|
        if @stock
          format.turbo_stream
          format.html { render 'users/my_portfolio' }
        else
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("messages", partial: "layouts/messages"),
              turbo_stream.update("results", "")
            ]
          end          
          format.html do
            flash[:alert] = "Please enter a valid symbol to search"
            redirect_to my_portfolio_path
          end
        end
      end
    else
      flash.now[:alert] = "Please enter a symbol to search"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("messages", partial: "layouts/messages"),
            turbo_stream.update("results", "")
          ]
        end        
        format.html do
          flash[:alert] = "Please enter a symbol to search"
          redirect_to my_portfolio_path
        end
      end
    end
  end
end