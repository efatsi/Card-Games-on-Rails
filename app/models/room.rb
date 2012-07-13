class Room < ActiveRecord::Base
  
    GAMES = ["Hearts", "Spades"]

    after_create :create_game
    
    has_many :games, :dependent => :destroy
    has_many :players, :through => :games
    
    validates_presence_of :game_type
    validates_inclusion_of :game_type, :in => GAMES

    attr_accessible :name, :game_type, :size

    
    def game
      game_id = games.last
      (game_type + "Game").constantize.find(game_id)
    end
    
    private
    def create_game
      case game_type
      when "Hearts"
        HeartsGame.create(:room_id => self.id, :size => 4)
      when "Spades"
        SpadesGame.create(:room_id => self.id, :size => 4)
      end
      update_size
    end
    
    def update_size
      self.size = self.games.last.size
      self.save
    end

  end
