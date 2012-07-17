class Player < ActiveRecord::Base
  
  attr_accessible :game_id, :user_id, :seat
  
  belongs_to :game
  belongs_to :user
  has_many :player_cards
  has_many :cards, :through => :player_cards
  has_many :played_cards, :through => :player_cards
  
  validates_presence_of :game_id
  validates_presence_of :user_id
  
  def hand
    self.reload.player_cards(true).joins("LEFT JOIN played_cards ON played_cards.player_card_id = player_cards.id").where("played_cards.id IS NULL").readonly(false)
  end
  
  def select_random_card
    hand[rand(hand.length)]
  end
  
  def choose_cards_to_pass
    selection = []
    until(selection.length == 3)
      choice = select_random_card
      selection << choice unless selection.include?(choice)
    end
    selection
  end
  
end
