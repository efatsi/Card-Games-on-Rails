class Game < ActiveRecord::Base
  
  attr_accessible :size, :winner_id

  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy

end
