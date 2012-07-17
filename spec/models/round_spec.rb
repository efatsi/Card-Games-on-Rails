require 'spec_helper'

describe Round do

  before do
    @game = FactoryGirl.create(:game, :size => 4)
    @user1 = FactoryGirl.create(:user, :username => "round_user1")
    @user2 = FactoryGirl.create(:user, :username => "round_user2")
    @user3 = FactoryGirl.create(:user, :username => "round_user3")
    @user4 = FactoryGirl.create(:user, :username => "round_user4")
    @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
    @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
    @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
    @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
    @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
    @players = @round.players
  end

  describe "#setup" do

    context "#new_round" do

      it "should show that round has been initiated" do
        @round.should be_an_instance_of Round
      end

      it "should know it's game parent" do
        @round.game.should == @game
      end

      it "should know it's player" do
        @round.players.length.should == 4
        @round.players.include?(@player1).should == true
      end

      it "should know who the dealer is" do
        @round.dealer.should == @player1
      end
      
      it "should know it's size" do
        @round.size.should == @game.size
      end

    end

  end

  describe "#methods" do

    context "deal_cards" do
      
      before do        
        create_cards
      end
      
      it "should deal 13 cards to every player" do
        @round.deal_cards
        @round.players.each do |player|
          player.hand.length.should == 13
        end
      end
    end
    
    context "pass_cards" do
      
      before do
        create_cards
        @round.deal_cards
      end
      
      it "should not crash" do
        @round.pass_cards(:left)
      end
      
      it "should pass 3 cards to the left" do
        current_1_hand = [] + @player1.hand
        current_2_hand = [] + @player2.hand
        @round.pass_cards(:left)
        new_cards = 0
        @player2.reload.hand.each do |card|
          if !current_2_hand.include?(card)
            new_cards += 1
            current_1_hand.should include(card)
          end
        end
        new_cards.should == 3
      end
      
      it "should pass 3 cards to the right" do
        current_1_hand = [] + @player1.hand
        current_4_hand = [] + @player4.hand
        @round.pass_cards(:right)
        new_cards = 0
        @player4.reload.hand.each do |card|
          if !current_4_hand.include?(card)
            new_cards += 1
            current_1_hand.should include(card)
          end
        end
        new_cards.should == 3
      end
        
      it "should pass 3 cards across" do
        current_1_hand = [] + @player1.hand
        current_3_hand = [] + @player3.hand
        @round.pass_cards(:across)
        new_cards = 0
        @player3.reload.hand.each do |card|
          if !current_3_hand.include?(card)
            new_cards += 1
            current_1_hand.should include(card)
          end
        end
        new_cards.should == 3
      end
      
      it "should not pass any cards for none" do
        current_1_hand = [] + @player1.hand
        @round.pass_cards(:none)
        new_cards = 0
        @player1.reload.hand.each do |card|
          new_cards += 1 unless current_1_hand.include?(card)
        end
        new_cards.should == 0
      end
    end
    
    context "two_of_clubs_owner" do
      
      it "should correctly find a Player" do
        create_cards
        @round.deal_cards
        @round.two_of_clubs_owner.should be_an_instance_of Player
      end
      
      it "should find the correct Player" do
        two_club = Card.create(:value => "2", :suit => "club")
        pc = PlayerCard.create(:player_id => @player1.id, :card_id => two_club.id)
        @round.two_of_clubs_owner.should == @player1
        pc.update_attributes(:player_id => @player2.id)
        @round.two_of_clubs_owner.should == @player2
      end      
    end
    
    context "get_new_leader" do
      
      it "should find the two of clubs owner without any tricks played" do
        two_club = Card.create(:value => "2", :suit => "club")
        pc = PlayerCard.create(:player_id => @player1.id, :card_id => two_club.id)
        @round.get_new_leader.should == @player1
      end
      
      it "should find last trick winner when trick(s) have been played" do
        first_trick = double("my first trick")
        trick = double("my trick")
        trick.stub(:trick_winner).and_return(@player4)
        @round.stub(:tricks).and_return([first_trick, trick])
        @round.get_new_leader.should == @player4
      end
    end
  
  end
  
  describe "#round_play" do
      
    context "making new tricks" do
      
      before do
        create_cards
        @round.deal_cards
      end
      
      it "should increment trick count of the round" do
        expect{ Trick.create(:round_id => @round.id, :leader_id => @player1.id) }.to change{ @round.tricks(true).length }.by(1)
      end
      
      it "should assign appropriate position to a new trick" do
        trick1 = Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => @round.tricks_played); @round.reload
        trick2 = Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => @round.tricks_played); @round.reload
        trick3 = Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => @round.tricks_played); @round.reload
        trick1.position.should == 0
        trick2.position.should == 1
        trick3.position.should == 2
      end
    end
    
  end

end


