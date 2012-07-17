class Round < ActiveRecord::Base
  
  PASS_SHIFT = {:left => 1, :across => 2, :right => 3, :none => 0}
  
  attr_accessible :game_id, :dealer_id
  
  belongs_to :game
  belongs_to :dealer, :class_name => "Player"
  has_many :tricks, :dependent => :destroy, :order => "position ASC"
  
  validates_presence_of :game_id
  validates_presence_of :dealer_id
  
  delegate :size, :players, :seated_at, :to => :game
  
  def deal_cards
    new_deck = Card.all
    13.times do
      4.times do |i|
        player = seated_at(i)
        random_card = new_deck[rand(new_deck.length)]
        PlayerCard.create(:player_id => player.id, :card_id => random_card.id) 
        new_deck.delete(random_card)
      end
    end    
  end
  
  def pass_cards(direction)
    return if direction == :none
    cards_to_pass = collect_cards_to_pass
    do_the_passing(cards_to_pass, direction)
  end
  
  def collect_cards_to_pass
    cards_to_pass = [ [] , [] , [] , [] ]
    players.each do |player|
      cards_to_pass[player.seat] = player.choose_cards_to_pass
    end
    cards_to_pass
  end
  
  def do_the_passing(cards_to_pass, direction)
    giving_shift = PASS_SHIFT[direction]
    cards_to_pass.each do |set|
      set.each do |player_card|
        new_seat = (player_card.player.seat + giving_shift) % 4
        player_card.update_attributes(:player_id => seated_at(new_seat).id)
      end
    end
  end
  
  def two_of_clubs_owner
    players.each do |player|
      player.hand.each do |card|
        if card.value == "2" && card.suit == "club"
          return player
        end
      end
    end
    nil
  end
  
  def get_new_leader
    tricks_played == 0 ? two_of_clubs_owner : last_trick.trick_winner
  end
  
  def tricks_played
    self.tricks.length
  end
  
  def last_trick
    tricks.last
  end
  
end
