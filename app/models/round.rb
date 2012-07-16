class Round < ActiveRecord::Base
  
  attr_accessible :game_id, :dealer_id
  
  belongs_to :game
  has_many :tricks, :dependent => :destroy
  
  validates_presence_of :game_id
  validates_presence_of :dealer_id

end
