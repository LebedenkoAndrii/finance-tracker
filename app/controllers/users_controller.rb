class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks if user_signed_in?
    @tracked_stocks ||= nil
    @user = current_user
  end

  def friends
    @friends_list = current_user.friends || []
    @friends = []
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def search
    @friends_list = current_user.friends
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = [] if @friends.nil?
      @friends = current_user.except_current_user(@friends)
      if @friends.any?
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("friend_result", partial: "friends/friend_result", locals: { friends: @friends })
          end
          format.html { render 'users/friends' }
        end
      else
        flash.now[:alert] = "Couldn`t find user"
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("messages", partial: "layouts/messages") }
          format.html { render 'users/friends' }
        end
      end
    else
      flash[:alert] = "Please enter a friend name or email to search"
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("messages", partial: "layouts/messages") }
        format.html { render 'users/friends' }
      end
    end
  end
end
