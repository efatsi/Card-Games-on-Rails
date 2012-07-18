Game.delete_all
Round.delete_all
Trick.delete_all
Player.delete_all
PlayerCard.delete_all
PlayedCard.delete_all
PlayerRound.delete_all
Card.delete_all

User.delete_all
User.create(:username => "efatsi", :password => "secret", :password_confirmation => "secret")
User.create(:username => "amelia")

# Make all of the cards you need
%w(club heart spade diamond).each do |suit|
  %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
    card = Card.create(:suit => suit, :value => value.to_s)
  end
end

Game.create(:name => "Hearts Baby")



# g = Game.create(:size => 4)
# u1 = User.create(:username => "user1")
# u2 = User.create(:username => "user2")
# u3 = User.create(:username => "user3")
# u4 = User.create(:username => "user4")
# Player.create(:game_id => 1, :user_id => u1.id, :seat => 1)
# Player.create(:game_id => 1, :user_id => u2.id, :seat => 2)
# Player.create(:game_id => 1, :user_id => u3.id, :seat => 3)
# Player.create(:game_id => 1, :user_id => u4.id, :seat => 4)
# r = Round.create(:game_id => g.id, :dealer_id => u1.id)