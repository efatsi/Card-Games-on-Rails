User.delete_all
Room.delete_all
Card.delete_all
Deck.delete_all
Game.delete_all
Team.delete_all

Room.create(:game_type => "Hearts", :name => "We Love Hearts")

4.times do |i|
  User.create(:username => "user_#{i}", :password => "secret", :password_confirmation => "secret")
end

User.create(:username => "efatsi", :password => "secret", :password_confirmation => "secret")