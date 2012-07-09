require 'spec_helper'

describe HeartsTrick do

  before :each do
    @hearts = HeartsGame.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user2 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user3 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user4 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @hearts_round = HeartsRound.create(:game_id => @hearts.id, :dealer_index => 0)
    @hearts_trick = HeartsTrick.create(:round_id => @hearts_round.id, :leader_index => 0)
    @deck = @hearts_trick.deck
    @players = @hearts_trick.players
  end
  
  describe "#setup" do
    
    context "new_trick" do
      
      it "should be a HeartsTrick" do
        @hearts_trick.should be_an_instance_of HeartsTrick
      end
      
      it "should know it's parent is a HeartsRound" do
        @hearts_trick.round.should be_an_instance_of HeartsRound
        @hearts_trick.round.should == @hearts_round
      end
      
      it "should know that hearts have not been broken" do
        @hearts_trick.hearts_broken.should == false
      end
      
    end
    
  end

  describe "#trick_play" do
    
    context "picking_cards" do
      
      before :each do
        @hearts_trick.round.deal_cards
      end
      
      it "should pick a card for the player" do
        @hearts_trick.pick_card(@user1).should be_an_instance_of Card
        @hearts_trick.pick_card(@user2).should be_an_instance_of Card
        @hearts_trick.pick_card(@user3).should be_an_instance_of Card
        @hearts_trick.pick_card(@user4).should be_an_instance_of Card
      end
      
    end
    
    context "play_trick" do
      
      before :each do
        @hearts_trick.round.deal_cards
        @hearts_trick.play_trick
      end
        
      it "should have generated a full PlayedTrick" do
        @hearts_trick.played_trick.should be_an_instance_of PlayedTrick
        @hearts_trick.played_trick.cards.length.should == 4
      end
      
      it "should have given the winner the PlayedTrick" do
        @hearts_trick.trick_winner.played_tricks.length.should == 1
      end
      
      it "should have taken a card from every player" do
        @players.each do |player|
          player.hand.length.should == 12
        end
      end
      
      
      
    end
    
  end
  
end
