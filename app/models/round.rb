class Round < ActiveRecord::Base
  
  attr_accessible :dealer_id, :room_id
  
  belongs_to :room
  has_many :tricks, :dependent => :destroy
  has_many :played_tricks, :as => :trick_owner, :dependent => :destroy
  
end
