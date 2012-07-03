class Room < ActiveRecord::Base

  has_many :decks, :dependent => :destroy
  has_many :users
  has_many :teams #sometimes

  after_create :new_deck
  before_destroy :clear_users_room_ids
  before_destroy :clear_teams_room_ids

  def new_deck
    Deck.create(:room_id => self.id)
  end

  def deck
    self.decks.first.cards
  end

  def clear_users_room_ids
    self.users.each {|user| update_attributes(:room_id => nil)}
  end

  def clear_teams_room_ids
    self.teams.each {|team| update_attributes(:room_id => nil)}
  end

end
