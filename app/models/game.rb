class Game < ActiveRecord::Base
  
  attr_accessible :room_id, :size, :winner_id

  after_create :load_deck
  before_destroy :clear_users_room_ids
  before_destroy :clear_teams_room_ids


  belongs_to :room
  has_many :decks, :dependent => :destroy
  has_many :players, :class_name => "User"
  has_many :teams, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
  
  def deck
    self.decks.first.cards
  end

  private

  def load_deck
    Deck.create(:room_id => self.id)
  end
  
  
  
  

end
