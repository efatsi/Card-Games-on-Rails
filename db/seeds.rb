User.delete_all
Room.delete_all
Card.delete_all
Deck.delete_all
Game.delete_all
Round.delete_all
Trick.delete_all
Team.delete_all

Room.create(:game_type => "Hearts", :name => "We Love Hearts")

User.create(:username => "efatsi", :password => "secret", :password_confirmation => "secret")
User.create(:username => "amelia")