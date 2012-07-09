class PlayedTrick < ActiveRecord::Base
  
  attr_accessible :size, :user_id, :trick_id
  
  belongs_to :player, :class_name => "user"
  belongs_to :trick
  has_many :cards, :as => :card_owner
  
  # validate :size_of_trick_is_valid, :before => :save
  # 
  # 
  # private
  # def size_of_trick_is_valid
  #   unless self.size == self.cards.length
  #     self.errors[:size] << 'Size does not match'
  #   end
  # end
  
end
