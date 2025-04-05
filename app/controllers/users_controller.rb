class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks if user_signed_in?
    @tracked_stocks ||= nil
  end

  def friends
    @friends_list = current_user.friends
    @friends_list = []
  end

  def search
    @friends_list = current_user.friends
    if params[:friend].present?
      @friends = User.search(params[:friend])
      if @friends
        render 'users/friends'
      else
        flash.now[:alert] = "Couldn`t find user"
        render 'users/friends'
      end    
    else
      flash[:alert] = "Please enter a friend name or email to search"
      render 'users/friends'
    end
  end
end
