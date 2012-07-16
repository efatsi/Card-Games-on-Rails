class Round < ActiveRecord::Base
  
  attr_accessible :dealer_seat, :game_id
  
  belongs_to :game
  has_many :tricks, :dependent => :destroy
  has_many :players, :through => :game
  has_many :decks, :through => :game

  
  def new_dealer_seat
    (dealer_seat + 1) % game.size
  end
  
  def deal_cards
    if deck.cards.length == 52
      13.times do
        4.times do |i|
          player = seated_at((dealer_seat+i+1)%4)
          card = deck.cards[rand(deck.cards.length)]
          deal_card_to_player(card, player)
        end
      end
    end
  end

  def return_cards
    players.each do |player|
      player.hand.each do |card|
        return_card_to_deck(card)
      end
      player.played_tricks(true) ## need this for round_spec
      player.played_tricks.each do |trick|
        trick.cards.each do |card|
          return_card_to_deck(card)
        end
      end
    end
  end
  
  def deck
    decks.last
  end
  
  def dealer
    seated_at(dealer_seat)
  end
  
  def get_leader_seat
    tricks_played == 0 ? two_of_clubs_owner_seat : last_trick.trick_winner_seat
  end
  
  def seated_at(seat)
    self.game.seated_at(seat)
  end

  def tricks_played
    self.reload.tricks.length  # need this for any upper level test (play_game, play_round)
  end
  
  def last_trick
    tricks.last
  end
  
  def deal_card_to_player(card, player)
    card.card_owner = player
    card.save
  end
  
  def return_card_to_deck(card)
    card.card_owner = deck
    card.save
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
