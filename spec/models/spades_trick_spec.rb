require 'spec_helper'

describe SpadesTrick do

  before :each do
    @spades = SpadesGame.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @spades.id)
    @user2 = FactoryGirl.create(:user, :game_id => @spades.id)
    @user3 = FactoryGirl.create(:user, :game_id => @spades.id)
    @user4 = FactoryGirl.create(:user, :game_id => @spades.id)
    @spades_round = SpadesRound.create(:game_id => @spades.id, :dealer_index => 0)
    @spades_trick = SpadesTrick.create(:round_id => @spades_round.id, :leader_index => 0)
    @deck = @spades_trick.deck
    @players = @spades_trick.players
  end
  
  describe "#setup" do
    
    context "new_trick" do
      
      it "should be a SpadesTrick" do
        @spades_trick.should be_an_instance_of SpadesTrick
      end
      
      it "should know it's parent is a SpadesRound" do
        @spades_trick.round.should be_an_instance_of SpadesRound
        @spades_trick.round.should == @spades_round
      end
      
      it "should know that spades have not been broken" do
        @spades_trick.spades_broken.should == false
      end
      
    end
    
  end

  describe "#trick_play" do
    
    context "picking_cards" do
      
      before :each do
        @spades_trick.round.deal_cards
      end
      
      it "should pick a card for the player" do
        @spades_trick.pick_card(@user1).should be_an_instance_of Card
        @spades_trick.pick_card(@user2).should be_an_instance_of Card
        @spades_trick.pick_card(@user3).should be_an_instance_of Card
        @spades_trick.pick_card(@user4).should be_an_instance_of Card
      end
      
    end
    
    context "play_trick" do
      
      before :each do
        @spades_trick.round.deal_cards
        @spades_trick.play_trick
      end
        
      it "should have generated a full PlayedTrick" do
        @spades_trick.played_trick.should be_an_instance_of PlayedTrick
        @spades_trick.played_trick.cards.length.should == 4
      end
      
      it "should have given the winner the PlayedTrick" do
        @spades_trick.trick_winner.played_tricks.length.should == 1
      end
      
      it "should have taken a card from every player" do
        @players.each do |player|
          player.hand.length.should == 12
        end
      end
      
      
      
    end
    
  end
  
end
