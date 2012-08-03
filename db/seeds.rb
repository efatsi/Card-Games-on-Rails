Game.delete_all
Round.delete_all
Trick.delete_all
Player.delete_all
PlayerCard.delete_all
PlayedCard.delete_all
PlayerRound.delete_all
Card.delete_all
CardPassingSet.delete_all

# User.delete_all
# User.create(:username => "efatsi", :password => "secret", :password_confirmation => "secret")
# User.create(:username => "amelia")

if User.all.empty?
  User.create(:username => "efatsi", :password => "secret", :password_confirmation => "secret")
  User.create(:username => "amelia")
  User.create(:username => "noah")
  User.create(:username => "parents")
end

# Make all of the cards you need
%w(club heart spade diamond).each do |suit|
  %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
    card = Card.create(:suit => suit, :value => value.to_s)
  end
end

Game.create(:name => "Hearts Baby1")
Game.create(:name => "Hearts Baby2")
Game.create(:name => "Hearts Baby3")
Game.create(:name => "Hearts Baby4")
Game.create(:name => "Hearts Baby5")
Game.create(:name => "Hearts Baby6")
Game.create(:name => "Hearts Baby7")
Game.create(:name => "Hearts Baby8")
Game.create(:name => "Hearts Baby9")
Game.create(:name => "Hearts Baby10")
