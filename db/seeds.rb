User.delete_all
Room.delete_all
Card.delete_all
Deck.delete_all
Game.delete_all
Team.delete_all

Room.create(:game_type => "hearts")

4.times do |i|
  User.create(:username => "user_#{i}", :password => "secret", :password_confirmation => "secret")
end