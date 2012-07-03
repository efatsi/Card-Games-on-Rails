class Room < ActiveRecord::Base
  
  has_many :decks
  has_many :players
  
  after_create :new_deck
  
  # attr_accessible :title, :body
  
  def new_deck
    Deck.create(:room_id => self.id)
  end
  
  def deck
    self.decks.first.cards
  end
  
end
