class Player < ActiveRecord::Base
  attr_accessible :game_id, :seat, :user_id
end
