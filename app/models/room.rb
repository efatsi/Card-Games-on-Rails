class Room < ActiveRecord::Base
  
    GAMES = ["hearts", "spades"]

    after_create :new_deck
    before_destroy :clear_users_room_ids
    before_destroy :clear_teams_room_ids

    has_many :decks, :dependent => :destroy
    has_many :players, :class_name => "User"
    has_many :teams, :dependent => :destroy
    has_many :rounds, :dependent => :destroy
    
    validates_presence_of :game
    validates_inclusion_of :game, :in => GAMES

    attr_accessible :game

    def deck
      self.decks.first.cards
    end

    private

    def new_deck
      Deck.create(:room_id => self.id)
    end

    def clear_users_room_ids
      self.users.each {|user| update_attributes(:room_id => nil)}
    end

    def clear_teams_room_ids
      self.teams.each {|team| update_attributes(:room_id => nil)}
    end

  end
