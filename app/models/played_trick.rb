class PlayedTrick < ActiveRecord::Base
  
  attr_accessible :size, :user_id, :trick_id
  
  belongs_to :player, :class_name => "User"
  belongs_to :trick
  has_many :cards, :as => :card_owner
  
  def player
    User.find(user_id)
  end
  
end
