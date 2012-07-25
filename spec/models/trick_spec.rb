require 'spec_helper'

describe Trick do
  
  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "trick_user1")
    @user2 = FactoryGirl.create(:user, :username => "trick_user2")
    @user3 = FactoryGirl.create(:user, :username => "trick_user3")
    @user4 = FactoryGirl.create(:user, :username => "trick_user4")
    @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
    @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
    @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
    @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
    @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
    @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
  end
  
  describe "#setup" do
    
    context "#new_trick" do
      
      it "should be a trick" do
        @trick.should be_an_instance_of Trick
      end
      
      it "should know about it's players" do
        @trick.players.length.should == 4
        @trick.players.include?(@player1).should == true
      end
      
      it "should know about it's round and game parents" do
        @trick.round.should == @round
        @trick.round.game.should == @game
      end
      
      it "should know who the leader is" do
        @trick.leader.should == @player1
      end      
    end
    
  end
  
  describe "#trick_play" do
    
    before do
      create_cards
      @round.deal_cards
    end
    
    context "starting with the two of clubs" do
      
      before do
        @trick.update_attributes(:leader_id => @round.send(:two_of_clubs_owner).id)
      end
      
      it "should work when called for" do
        @trick.send(:start_with_two_of_clubs)
        @trick.played_cards(true).length.should == 1
        card = @trick.played_cards.first
        card.value.should == "2"; card.suit.should == "club"
      end
    end
    
    context "getting a card from a player" do
      
      it "should increment PlayedCard existence by 1" do
        expect { @trick.play_card_from(@player1) }.to change{PlayedCard.count}.by(1)
      end 
      
      it "should decrement the players hand count by 1" do
        expect { @trick.play_card_from(@player2) }.to change{@player2.hand.length}.by(-1)
      end
      
      it "should be accessible from the trick" do
        expect { @trick.play_card_from(@player3) }.to change{@trick.played_cards(true).length}.by(1)        
      end
      
      it "should increment the position of the played_cards" do
        @trick.play_card_from(@player1)
        @trick.reload
        @trick.play_card_from(@player2)
        [@player1.played_cards.first.position, @player2.played_cards.first.position].should == [0,1]
      end
    end
    
    context "setting the lead suit" do
      
      it "should set the lead suit after the first card is played" do
        @trick.update_attributes(:leader_id => @player2.id)
        expect { @trick.play_card_from(@player2) }.to change{@trick.lead_suit}.from(nil)   
        %w(club heart spade diamond).should include(@trick.lead_suit)     
      end
      
      it "should not change the lead suit after the first card is played" do
        @trick.play_card_from(@player2)
        @trick.reload
        expect { @trick.play_card_from(@player3) }.to_not change{@trick.lead_suit}
      end
    end
    
    context "getting the next player" do
      
      before do
        @trick.stub(:next_position).and_return(1)
      end
      
      it "should return player who's seat is one greater (mod 4)" do
        @trick.update_attributes(:leader_id => @player1.id)
        @trick.next_player.should == @player2
      end
      it "should return player who's seat is one greater (mod 4)" do
        @trick.update_attributes(:leader_id => @player4.id)
        @trick.next_player.should == @player1
      end
    end
    
    context "cards being played" do
      
      before do
        @trick.play_card_from(@player1); @trick.reload
        @trick.play_card_from(@player2); @trick.reload
      end
      
      it "should know how many cards have been played" do
        @trick.cards_played.should == 2
      end
      
      it "should know that the game is not over with < 4 cards played" do
        @trick.play_card_from(@player3); @trick.reload
        @trick.is_not_over?.should == true
        @trick.is_over?.should == false
      end
      
      it "should display trick info correctly" do
        display = @trick.display_trick_info
        display.should include("Trick is lead by trick_user1, it is trick_user3's turn")
      end
    end
    
    context "after all cards are played" do
      
      before do
        @trick.play_card_from(@player1); @trick.reload
        @trick.play_card_from(@player2); @trick.reload
        @trick.play_card_from(@player3); @trick.reload
        @trick.play_card_from(@player4); @trick.reload
      end
      
      it "should be able to determine a winning card" do
        @trick.send(:winning_card).should be_an_instance_of PlayedCard
      end
      
      it "should be able to determine the winner" do
        @trick.trick_winner.should be_an_instance_of Player
      end
      
      it "should know it is over" do
        @trick.is_not_over?.should == false
        @trick.is_over?.should == true
      end
      
      it "should display trick info correctly" do
        display = @trick.display_trick_info
        display.should include("Trick was lead by trick_user1 and won by trick_user")
        display.should include("The lead suit was ")
      end
    end
    
  end
  
  describe "finding the winner and score" do
    
    context "when all clubs are played" do
      
      before do
        @c1 = FactoryGirl.create(:card, :suit => "club", :value => "2")
        @c2 = FactoryGirl.create(:card, :suit => "club", :value => "5")
        @c3 = FactoryGirl.create(:card, :suit => "club", :value => "J")
        @c4 = FactoryGirl.create(:card, :suit => "club", :value => "A")
        @p1 = FactoryGirl.create(:player_card, :player_id => @player1.id, :card_id => @c1.id)
        @p2 = FactoryGirl.create(:player_card, :player_id => @player2.id, :card_id => @c2.id)
        @p3 = FactoryGirl.create(:player_card, :player_id => @player3.id, :card_id => @c3.id)
        @p4 = FactoryGirl.create(:player_card, :player_id => @player4.id, :card_id => @c4.id)
        @pc1 = FactoryGirl.create(:played_card, :player_card_id => @p1.id, :trick_id => @trick.id, :position => 0)
        @pc2 = FactoryGirl.create(:played_card, :player_card_id => @p2.id, :trick_id => @trick.id, :position => 1)
        @pc3 = FactoryGirl.create(:played_card, :player_card_id => @p3.id, :trick_id => @trick.id, :position => 2)
        @pc4 = FactoryGirl.create(:played_card, :player_card_id => @p4.id, :trick_id => @trick.id, :position => 3)
      end
    
      it "should determine the correct winning card" do
        @trick.send(:winning_card).should == @pc4
      end
      
      it "should do it again" do
        @c4.update_attributes(:value => "3")
        @trick.send(:winning_card).should == @pc3
      end
      
      it "should know the trick winning player" do
        @trick.trick_winner.should == @player4
      end
      
      it "should know the score of the trick" do
        @trick.trick_score.should == 0
      end
      
    end
    
    context "when mixed suits are played" do
      
      before do
        @c1 = FactoryGirl.create(:card, :suit => "club", :value => "2")
        @c2 = FactoryGirl.create(:card, :suit => "heart", :value => "5")
        @c3 = FactoryGirl.create(:card, :suit => "spade", :value => "J")
        @c4 = FactoryGirl.create(:card, :suit => "diamond", :value => "A")
        @p1 = FactoryGirl.create(:player_card, :player_id => @player1.id, :card_id => @c1.id)
        @p2 = FactoryGirl.create(:player_card, :player_id => @player2.id, :card_id => @c2.id)
        @p3 = FactoryGirl.create(:player_card, :player_id => @player3.id, :card_id => @c3.id)
        @p4 = FactoryGirl.create(:player_card, :player_id => @player4.id, :card_id => @c4.id)
        @pc1 = FactoryGirl.create(:played_card, :player_card_id => @p1.id, :trick_id => @trick.id, :position => 0)
        @pc2 = FactoryGirl.create(:played_card, :player_card_id => @p2.id, :trick_id => @trick.id, :position => 1)
        @pc3 = FactoryGirl.create(:played_card, :player_card_id => @p3.id, :trick_id => @trick.id, :position => 2)
        @pc4 = FactoryGirl.create(:played_card, :player_card_id => @p4.id, :trick_id => @trick.id, :position => 3)
      end
    
      it "should determine the correct winning card" do
        @trick.send(:winning_card).should == @pc1
      end
      
      it "should do it again" do
        @c4.update_attributes(:suit => "club")
        @trick.send(:winning_card).should == @pc4
      end

      it "should know the trick winning player" do
        @trick.trick_winner.should == @player1
      end
      
      it "should find the score of the trick" do
        @trick.trick_score.should == 1
      end
      
      it "should find the score if the Q of Spades is present" do
        @c3.update_attributes(:value => "Q")
        @trick.trick_score.should == 14
      end
    end
    
  end
  
  describe "play_trick" do
    
    before do
      create_cards
      @round.deal_cards
    end
    
    it "should not crash" do
      @trick.play_trick
    end
  end
    
end
