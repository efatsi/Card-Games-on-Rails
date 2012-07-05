class Trick < ActiveRecord::Base
  
  attr_accessible :lead_suit, :leader_id, :round_id
  
  belongs_to :round

end
