class Player < ActiveRecord::Base
  
  attr_accessible :game_id, :user_id, :seat
  
  belongs_to :game
  belongs_to :user
  
  validates_presence_of :game_id
  validates_presence_of :user_id
  
end
