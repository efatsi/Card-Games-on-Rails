require 'spec_helper'

describe Trick do
  
  before :each do
    @game = Game.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @game.id)
    @user2 = FactoryGirl.create(:user, :game_id => @game.id)
    @user3 = FactoryGirl.create(:user, :game_id => @game.id)
    @user4 = FactoryGirl.create(:user, :game_id => @game.id)
    @round = Round.create(:game_id => @game.id, :dealer_index => 0)
    @trick = Trick.create(:round_id => @round.id, :leader_index => 0)
    @deck = @trick.deck
    @players = @trick.players
  end
  
  describe "#setup" do
    
    context "#new_trick" do
      
      it "should be a trick" do
        @trick.should be_an_instance_of Trick
      end
      
      it "should know about it's players" do
        @trick.players.length.should == 4
        @trick.players.include?(@user1).should == true
      end
      
      it "should know about it's deck" do
        @deck.should be_an_instance_of Deck
        @deck.cards.length.should == 52
      end
      
      it "should know about it's round and game parents" do
        @trick.round.should == @round
        @trick.round.game.should == @game
      end
      
      it "should know who the leader is" do
        @trick.leader.should == @user1
      end
      
      it "should know it's game size" do
        @trick.size.should == 4
      end
      
      it "should not have a played_trick yet" do
        @trick.played_trick.should == nil
      end
      
    end
    
  end
  
  describe "#trick_play" do
    
    context "a trick has been played but not stored" do
      
      before :each do
        @played_cards = []
        4.times do |i|
          card = @deck.cards[13*i + rand(5)]
          @played_cards << card
        end      
      end
      
      it "should store a trick in a PlayedTrick" do
        @trick.played_trick.should == nil
        @trick.store_trick(@played_cards)
        @trick.played_trick.should be_an_instance_of PlayedTrick
        @trick.played_trick.cards.length.should == 4
      end
      
    end
    
    context "a trick has been played and stored" do
      
      before :each do
        trick = PlayedTrick.create(:size => 4, :trick_id => @trick.id)
        4.times do |i|
          card = @deck.cards.last ## (2 through 5 of clubs)
          card.card_owner = trick
          card.save
        end      
      end
      
      it "should know it has a played_trick" do
        @trick.played_trick.should be_an_instance_of PlayedTrick
      end

      it "should know the index of the trick winner" do
        @trick.trick_winner_index.should == @players.index(@trick.trick_winner)
      end
      
      it "should know the last player won the trick" do
        @trick.trick_winner.should == @players[0]
      end
      
      it "should give the trick to the winner" do
        @trick.give_trick_to_winner
        total = 0
        @players[0].played_tricks.length.should == 1
      end
      
    end
    
  end
end
