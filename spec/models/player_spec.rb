require 'spec_helper'

describe Player do
  
  before do
    User.delete_all
    @game = FactoryGirl.create(:game)
    create_users; create_players; create_cards
    @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
  end
  
  describe "resource_knowledge" do
    
    it "should know it is a played_card" do
      @player1.should be_an_instance_of Player
    end
  end
  
  describe "#methods" do
    
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
    
    context "master or bystander" do
      
      it "should know who the master is" do
        @player1.is_game_master?.should == true
        @player2.is_game_master?.should == false
        @player3.is_game_master?.should == false
        @player4.is_game_master?.should == false
      end
      
      it "should know who is a bystander" do
        @player1.is_a_bystander?.should == false
        @player2.is_a_bystander?.should == true
        @player3.is_a_bystander?.should == true
        @player4.is_a_bystander?.should == true
      end
    end
    
    context "has_passed?" do
      
      it "should work" do
        @player1.card_passing_set.update_attributes(:is_ready => true)
        @player1.has_passed?.should == true
        @player2.card_passing_set.update_attributes(:is_ready => false)
        @player2.has_passed?.should == false
      end
    end
    
    context "ready_to_pass?" do
      
      before do
        @player1.card_passing_set.update_attributes(:is_ready => false)
      end
      
      it "should be false if < 3 cards have been passed" do
        @player1.card_passing_set.player_cards.each{|c| c.destroy}
        @player1.ready_to_pass?.should == false
      end
      
      it "should be false if set is_ready" do
        @round.fill_computer_passing_sets
        @player1.card_passing_set.update_attributes(:is_ready => false)
        @player1.ready_to_pass?.should == true
      end
      
      it "should be true if 3 cards have been chosen and set !is_ready?" do
        @round.fill_computer_passing_sets
        @player1.ready_to_pass?.should == true
      end
    end
  end
  
  
end
