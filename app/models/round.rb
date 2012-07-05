class Round < ActiveRecord::Base
  
  attr_accessible :dealer_id, :game_id
  
  belongs_to :game
  has_many :tricks, :dependent => :destroy
  has_many :played_tricks

  
  def shuffle_cards
    2.times do
      new_deck = []
      @deck.each do |card|
        new_location = rand(new_deck.size+1)
        new_deck.insert(new_location, card)
      end
      @deck = new_deck
    end
  end
  
  def deal_cards
    if @deck.length == 52
      dealer_index = @players.index(@dealer)
      13.times do
        4.times do |i|
          player = @players[(dealer_index+i+1)%4]
          top = @deck.last
          player.hand << top
          @deck.delete(top)
        end
      end
    end
  end

  def return_cards
    @players.each do |player|
      player.hand.each do |card|
        @deck << card
      end
      player.round_collection.each do |card|
        @deck << card
      end
      player.hand = []
      player.round_collection = []
    end
  end
  
  
end
