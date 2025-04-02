class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks if user_signed_in?
    @tracked_stocks ||= nil
  end
end
