class PlayedTrick < ActiveRecord::Base
  
  attr_accessible :size, :trick_owner_id, :trick_owner_type
  
  belongs_to :trick_owner, :polymorphic => true
  has_many :cards, :as => :card_owner
  
  validate :size_of_trick_is_valid
  
  
  private
  def size_of_trick_is_valid
    unless self.size == self.cards.length
      self.errors[:size] << 'Size does not match'
    end
  end
  
end
