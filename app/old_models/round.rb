class Round < ActiveRecord::Base
  
  PASS_SHIFT = {:left => 1, :across => 2, :right => 3, :none = 0}
  
  attr_accessible :dealer_seat, :game_id
  
  belongs_to :game
  has_many :tricks, :dependent => :destroy
  has_many :players, :through => :game
  
  def new_dealer_seat
    (dealer_seat + 1) % game.size
  end
  
  def deal_cards
    new_deck = Card.all
    13.times do
      4.times do |i|
        player = player_seated_at((dealer_seat+i+1)%4)
        random_card = new_deck[rand(new_deck.length)]
        player.cards << random_card  
        new_deck.delete(random_card)
      end
    end
  end
  
  def dealer
    player_seated_at(dealer_seat)
  end
  
  def get_leader_seat
    tricks_played == 0 ? two_of_clubs_owner_seat : last_trick.trick_winner_seat
  end
  
  def player_seated_at(seat)
    self.game.player_seated_at(seat)
  end

  def tricks_played
    self.reload.tricks.length  # need this for any upper level test (play_game, play_round)
  end
  
  def last_trick
    tricks.last
  end
  
  def deal_card_to_player(card, player)

  end

  def two_of_clubs_owner_seat
    players.each do |player|
      player.hand.each do |card|
        if card.value == "2" && card.suit = "club"
          return player.seat
        end
      end
    end
    8000000000
  end
  
  def size
    game.size
  end
  
end
