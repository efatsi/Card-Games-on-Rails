class Deck < ActiveRecord::Base
  
  attr_accessible :game_id

  after_create :fill_deck
  
  belongs_to :game
  has_many :cards, :as => :card_owner, :dependent => :destroy
  
  private
  
  def fill_deck
    %w(club heart spade diamond).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
        card = Card.create(:suit => suit, :value => value.to_s, :card_owner => self)
      end
    end
  end
end
