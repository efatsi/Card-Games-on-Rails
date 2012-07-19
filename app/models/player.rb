class Player < ActiveRecord::Base
  
  attr_accessible :game_id, :user_id, :seat, :total_score
  
  belongs_to :game
  belongs_to :user
  has_many :player_cards
  has_many :cards, :through => :player_cards
  has_many :played_cards, :through => :player_cards
  has_many :player_rounds, :order => "created_at ASC"
  
  validates_presence_of :game_id
  validates_presence_of :user_id
  validates_presence_of :seat
  validates_presence_of :total_score
  
  delegate :username, :to => :user
  delegate :round_score, :to => :last_player_round
  
  def hand
    self.reload.player_cards(true).joins("LEFT JOIN played_cards ON played_cards.player_card_id = player_cards.id").where("played_cards.id IS NULL").readonly(false)
  end
  
  def choose_card(lead_suit)
    if has_none_of?(lead_suit)
      select_random_card
    else
      hand.each do |card|
        return card if card.suit == lead_suit
      end
    end
  end

  def has_none_of?(suit)
    self.hand.each do |card|
      return false if card.suit == suit
    end
    true
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
  
  def last_player_round
    player_rounds.last
  end
  
  def two_of_clubs
    player_cards.each do |card|
      return card if (card.value == "2" && card.suit == "club")
    end
    nil
  end
  
  
end
