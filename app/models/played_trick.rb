class PlayedTrick < ActiveRecord::Base
  
  attr_accessible :size, :player_id, :round_id
  
  belongs_to :player
  belongs_to :round
  has_many :cards, :as => :card_owner
  
  validate :size_of_trick_is_valid, :before => :save
  
  
  private
  def size_of_trick_is_valid
    unless self.size == self.cards.length
      self.errors[:size] << 'Size does not match'
    end
  end
  
end
