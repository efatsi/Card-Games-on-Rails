require 'spec_helper'

describe Game do
  
  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "game_player1", :game_id => @game.id, :seat => 0)
    @user2 = FactoryGirl.create(:user, :username => "game_player2", :game_id => @game.id, :seat => 1)
    @user3 = FactoryGirl.create(:user, :username => "game_player3", :game_id => @game.id, :seat => 2)
    @user4 = FactoryGirl.create(:user, :username => "game_player4", :game_id => @game.id, :seat => 3)
  end

  describe "#setup" do

    context "#new_game" do

      it "should show that game has been initiated" do
        @game.should be_an_instance_of Game
      end
      
      it "should not be over already" do
        @game.game_over?.should == false
      end
      
      it "should know it's size" do
        @game.size.should == 4
      end
      
    end
    
    context "#deck" do
      
      it "should know about it's deck" do
        @game.reload.deck.should be_an_instance_of Deck
      end
      
    end
    
    context "#players" do
      
      it "should know about it's players" do
        @game.players.length.should == 4
      end

    end

  end

  describe "#methods" do
    
    context "reset_for_new_game" do
      
      it "should work" do
        @game.update_attributes(:winner_id => 2)
        @game.winner_id.should == 2
        @game.reset_for_new_game
        @game.winner_id.should == nil
      end
    end
    
    context "clear_players_game_ids" do
      
      it "should work" do
        @game.clear_players_game_ids
        @game.players.each do |player|
          player.game_id.should == nil
        end
      end
    end
    
    context "destroy_and_load_new_deck" do
      
      it "should work" do
        @game.decks(true).length.should == 1
        old_deck = @game.deck
        @game.destroy_and_load_new_deck
        @game.decks(true).length.should == 1
        old_deck.should_not == @game.deck
      end
    end
    
    context "last_round" do
      
      it "should work with one round" do
        new_round = FactoryGirl.create(:round, :game_id => @game.id)
        @game.reload.last_round.should == new_round
      end
      
      it "should work with a few rounds" do
        next_round = FactoryGirl.create(:round, :game_id => @game.id)
        newest_round = FactoryGirl.create(:round, :game_id => @game.id)
        @game.reload.last_round.should == newest_round
      end
    end
    
    context "seated_at" do
      
      it "should work" do
        @game.seated_at(0).should == @user1
      end
    end
    
    context "next_seat" do
      
      it "should work" do
        @game.next_seat.should == @game.players.length
      end
    end
    
  end
end
