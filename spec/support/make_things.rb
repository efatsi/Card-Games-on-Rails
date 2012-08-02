module MakeThings
  
  def create_cards
    %w(club heart spade diamond).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
        card = FactoryGirl.create(:card, :suit => suit, :value => value.to_s)
      end
    end
  end
  
  def create_players
    @player1 = FactoryGirl.create(:player, :game_id => @game.id, :seat => 0)
    @player2 = FactoryGirl.create(:player, :game_id => @game.id, :seat => 1)
    @player3 = FactoryGirl.create(:player, :game_id => @game.id, :seat => 2)
    @player4 = FactoryGirl.create(:player, :game_id => @game.id, :seat => 3)
  end
  
  def create_users
    @user1 = FactoryGirl.create(:user, :username => "user1")
    @user2 = FactoryGirl.create(:user, :username => "user2")
    @user3 = FactoryGirl.create(:user, :username => "user3")
    @user4 = FactoryGirl.create(:user, :username => "user4")
  end

end