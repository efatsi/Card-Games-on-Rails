# User.delete_all
# Card.delete_all
# Game.delete_all
# Round.delete_all
# Trick.delete_all
# 

User.create(:username => "efatsi", :password => "secret", :password_confirmation => "secret")
User.create(:username => "amelia")

# Make all of the cards you need
%w(club heart spade diamond).each do |suit|
  %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
    card = Card.create(:suit => suit, :value => value.to_s)
  end
end