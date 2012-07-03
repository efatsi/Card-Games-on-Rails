class User < ActiveRecord::Base
  
  attr_accessible :bid, :going_blind, :going_nil, :round_score, :team_id, :total_score, :username
  
  belongs_to :team #sometimes
    
end
