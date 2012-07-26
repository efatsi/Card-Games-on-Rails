require 'spec_helper'

describe Player do
  
  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "player_user1")
    @user2 = FactoryGirl.create(:user, :username => "player_user2")
    @user3 = FactoryGirl.create(:user, :username => "player_user3")
    @user4 = FactoryGirl.create(:user, :username => "player_user4")
    @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
    @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
    @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
    @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
    @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
    create_cards
  end
  
  describe "resource_knowledge" do
    
    it "should know it is a played_card" do
      @player1.should be_an_instance_of Player
    end
  end
  
  describe "#methods" do
    
    before do
      @round.deal_cards
    end
    
    context "two_of_clubs" do
      
      it "should bring up the two of clubs" do
        owner = @round.send(:two_of_clubs_owner)
        card_chosen = owner.two_of_clubs
        card_chosen.should be_an_instance_of PlayerCard
        card_chosen.value.should == "2"; card_chosen.suit.should == "club"
      end
    end
    
    context "cards_to_pass" do
      
      it "should return all of the cards the player has chosen to pass" do
        @round.fill_computer_passing_sets
        @player1.cards_to_pass.length.should == 3
        @player1.cards_to_pass.each do |card|
          card.should be_an_instance_of PlayerCard
        end
      end
    end
    
  end
  
  
end
