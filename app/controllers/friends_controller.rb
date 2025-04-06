class FriendsController < ApplicationController
  def index
    friends = Friendship.all
  end
end
