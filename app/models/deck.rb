class Deck < ActiveRecord::Base

  after_create :fill_deck
  
  belongs_to :room
  has_many :cards, :dependent => :destroy
  
  attr_accessible :room_id
  
  def fill_deck
    %w(club heart spade diamond).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
        card = Card.create(:suit => suit, :value => value.to_s, :deck_id => self.id)
      end
    end
  end
end
