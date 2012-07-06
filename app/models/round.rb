class Round < ActiveRecord::Base
  
  attr_accessible :dealer_index, :game_id
  
  belongs_to :game
  has_many :tricks, :dependent => :destroy

  
  def new_dealer_index
    (dealer_index + 1) % game.size
  end
  
  # private
  
  def deal_cards
    if deck.cards.length == 52
      dealer_index = players.index(dealer)
      13.times do
        4.times do |i|
          player = players[(dealer_index+i+1)%4]
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
      player.played_tricks.each do |trick|
        trick.cards.each do |card|
          return_card_to_deck(card)
        end
      end
    end
  end
  
  def deck
    game.decks.first
  end
  
  def players
    game.players
  end
  
  def dealer
    players[dealer_index]
  end
  
  def get_leader_index
    tricks_played == 0 ? two_of_clubs_owner_index : last_trick.trick_winner_index
  end

  def tricks_played
    tricks.length
  end
  
  def last_trick
    tricks.last
  end
  
  def deal_card_to_player(card, player)
    card.card_owner_type = "User"
    card.card_owner_id = player.id
    card.save
  end
  
  def return_card_to_deck(card)
    card.card_owner_type = "Deck"
    card.card_owner_id = deck.id
    card.save
  end

  def two_of_clubs_owner_index
    players.each do |player|
      player.hand.each do |card|
        if card.suit == "club" && card.value = "2"
          return players.index(player)
        end
      end
    end
    8
  end
  
end
