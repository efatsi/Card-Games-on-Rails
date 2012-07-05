class Round < ActiveRecord::Base
  
  attr_accessible :dealer_id, :game_id
  
  belongs_to :game
  has_many :tricks, :dependent => :destroy

  
  def shuffle_cards
    2.times do
      shuffled_deck = []
      deck.each do |card|
        new_location = rand(new_deck.size+1)
        shuffled_deck.insert(new_location, card)
      end
      game.decks.first = shuffled_deck
    end
  end
  
  
  def deal_cards
    if deck.length == 52
      dealer_index = players.index(dealer)
      13.times do
        4.times do |i|
          player = players[(dealer_index+i+1)%4]
          top = deck.last
          player.hand << top
          deck.delete(top)
        end
      end
    end
  end

  def return_cards
    played_tricks.each do |trick|
      trick.cards.each do |card|
        deck << card
        trick.delete(card)
      end
    end
    players.each do |player|
      player.hand.each do |card|
        deck << card
        player.hand.delete(card)
      end
    end
  end
  
  def new_dealer_id
    (dealer_id + 1) % game.size
  end
  
  def deck
    game.decks.first
  end
  
  def players
    game.players
  end
  
  def dealer
    User.find(dealer_id)
  end
  
  def get_leader_id
    tricks_played == 0 ? two_of_clubs_owner.id : last_trick.trick_winner_id
  end

  def tricks_played
    tricks.length
  end
  
  def last_trick
    tricks.last
  end
  
end
