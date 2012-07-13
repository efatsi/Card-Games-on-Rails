class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  include SimplestAuth::Controller
  include CardGames::Authentication
  
  before_filter :occupy_no_room
  
  def occupy_no_room
    if in_a_room
      current_user.update_attributes(:game_id => nil)
      current_user.hand.delete_all
    end
  end
  
  def in_a_room
    current_user && current_user.game_id.present?
  end
  
end
