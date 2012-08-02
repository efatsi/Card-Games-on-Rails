require 'spec_helper'

describe Game do

  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "game_user1")
    @user2 = FactoryGirl.create(:user, :username => "game_user2")
    @user3 = FactoryGirl.create(:user, :username => "game_user3")
    @user4 = FactoryGirl.create(:user, :username => "game_user4")
  end

  describe "#setup" do

    context "#new_game" do

      it "should show that game has been initiated" do
        @game.should be_an_instance_of Game
      end

      it "should not be over already" do
        @game.is_over?.should == false
      end
    end

    context "#players" do

      it "should know about any players" do
        create_players
        @game.players.length.should == 4
      end
    end

  end

  describe "#game_not_full" do

    it "should know if the game is full" do
      @game.is_full?.should == false
      @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
      @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
      @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
      @game.is_full?.should == false
      @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      @game.is_full?.should == true
    end

    context "next_seat" do

      it "should work with no one in the room" do
        @game.next_seat.should == 0
      end

      it "should work as people enter the room" do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @game.next_seat.should == 1
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @game.next_seat.should == 2
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @game.next_seat.should == 3
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
        @game.next_seat.should == 4
      end
    end

    context "last_round" do

      it "should return nil if no rounds have been played" do
        @game.last_round.should be_nil
      end

      it "should return the correct round with multiple" do
        create_cards; create_players        
        @round1 = FactoryGirl.create(:round, :game_id => @game.id, :position => @game.next_round_position); @game.reload
        @round2 = FactoryGirl.create(:round, :game_id => @game.id, :position => @game.next_round_position); @game.reload
        @round3 = FactoryGirl.create(:round, :game_id => @game.id, :position => @game.next_round_position); @game.reload
        @game.last_round.should == @round3
      end
    end

  end

  describe "#game_is_full" do

    before do
      create_cards; create_players
    end

    context "get_new_dealer" do

      it "should select the player seated at 0 when no rounds have been played" do
        @game.get_new_dealer.should == @player1
      end

      it "should select the player CCW of the last round's dealer when rounds have been played" do
        @round1 = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player3.id, :position => @game.next_round_position); @game.reload
        @game.get_new_dealer.should == @player4                                                                  
        @round1 = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player4.id, :position => @game.next_round_position); @game.reload
        @game.get_new_dealer.should == @player1
      end
    end

    context "find_lowest_player" do

      it "should work" do
        @player1.update_attributes(:total_score => 10)
        @player2.update_attributes(:total_score => 3)
        @player3.update_attributes(:total_score => 24)
        @player4.update_attributes(:total_score => 5)
        @game.send(:find_lowest_player).should == @player2
      end
    end

    context "check_for_and_set_winner" do

      it "should work if no one has won yet" do
        @player1.update_attributes(:total_score => 10)
        @player2.update_attributes(:total_score => 39)
        @player3.update_attributes(:total_score => 24)
        @player4.update_attributes(:total_score => 24)        
        @game.send(:check_for_and_set_winner)
        @game.is_over?.should == false
      end

      it "should work if some on does win" do
        @player1.update_attributes(:total_score => 120)
        @player2.update_attributes(:total_score => 40)
        @player3.update_attributes(:total_score => 12)
        @player4.update_attributes(:total_score => 120)
        @game.send(:check_for_and_set_winner)
        @game.is_over?.should == true
        @game.winner.should == @player3
      end
    end

    context "already_has?(user)" do
      
      before do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      end

      it "should work for a user/player in the game" do
        @game.already_has?(@user1).should == true
        @game.already_has?(@player1).should == true
      end

      it "should work for a user/player not in the game" do
        @user5 = FactoryGirl.create(:user, :username => "game_user5")
        @player5 = FactoryGirl.create(:player, :game_id => @game.id + 1, :user_id => @user5.id, :seat => 0)
        @game.already_has?(@user5).should == false
      end
    end

    context "get_lead_suit" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should get the lead_suit" do
        @trick.update_attributes(:lead_suit => "spade")
        @game.get_lead_suit.should == "spade"
      end
    end

    context "is_current_players_turn?(player)" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should know the leader is next at the start" do
        @game.is_current_players_turn?(@player1).should == true
      end

      it "should know player 2 is next after player1" do
        @trick.play_card_from(@player1, @player1.hand.first); @trick.reload
        @game.is_current_players_turn?(@player2).should == true
      end
    end

    context "last_trick" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should know it's last trick" do
        @game.last_trick.should == @trick
        @trick2 = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player2.id)
        @game.last_trick.should == @trick2
      end
    end

    context "played_cards" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should know about cards that have been played" do
        @trick.play_card_from(@player1); @trick.reload
        @trick.play_card_from(@player2); @trick.reload
        @game.played_cards.length.should == 2
      end
    end

  end

  describe "#situations" do

    before do
      create_cards; create_players
    end

    context "new_round_time" do

      it "should return true at start without any rounds" do
        @game.new_round_time?.should == true
      end

      it "should return true if rounds exist but last round is over" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(true)
        @game.new_round_time?.should == true
      end

      it "should return false if rounds exist and last one is not over" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @game.new_round_time?.should == false
      end
    end

    context "passing_time" do
      
      it "should throw it to last_round" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.should_receive(:try).with(:passing_time?)
        @game.passing_time?
      end
    end


    context "new_trick_time?" do
      
      it "should throw it to last_round" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.should_receive(:try).with(:is_ready_for_a_new_trick?)
        @game.new_trick_time? 
      end
    end

    context "mid_trick_time?" do
      
      it "should throw it to last_round" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.should_receive(:try).with(:has_an_active_trick?)
        @game.mid_trick_time? 
      end
    end

    
    context "is_ready_for_a_new_trick?" do
      
      it "should throw the call to it's own new_trick_time? method" do
        @game.should_receive(:new_trick_time?)
        @game.is_ready_for_a_new_trick?
      end
    end
    
    context "is_ready_for_a_new_round?" do
      
      it "should return true if is_full, new_round_time, and is_not_over" do
        @game.stub(:is_full?).and_return(true)
        @game.stub(:new_round_time?).and_return(true)
        @game.stub(:is_not_over?).and_return(true)
        @game.is_ready_for_a_new_round?.should == true
      end
    end
    
    context "ready_to_pass?" do
      
      it "should return true if passing_time? and passing_sets_are_ready?" do
        @game.stub(:passing_time?).and_return(true)
        @game.stub(:passing_sets_are_ready?).and_return(true)
        @game.ready_to_pass?.should == true
      end
    end
    
    context "trick_is_first?" do
      
      it "should pass call to last_trick" do
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.should_receive(:trick_is_first?)
        @game.trick_is_first?
      end
    end
    
    context "has_more_than_one_trick?" do
      
      it "should return false with no rounds" do
        @game.has_more_than_one_trick?.should == false
      end
      
      it "should return false with no tricks" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => 1)
        @game.has_more_than_one_trick?.should == false
      end
      
      it "should return false with one trick" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => 1)
        FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => 2)
        @game.has_more_than_one_trick?.should == false
      end
      
      it "should return false with > 1 tricks" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => 1)
        FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => 2)
        FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => 2)
        @game.has_more_than_one_trick?.should == true
      end
    end

    context "computer_should_play?" do

      it "should not crash" do
        @game.computer_should_play?
      end
    end

    context "should_reload?" do

      it "should not crash" do
        @game.should_reload?(@player2)
      end
    end

    context "master_should_reload?" do

      it "should not crash" do
        @game.computer_should_play?
      end
    end

    context "waiting_for_others_to_pass?" do

      it "should not crash" do
        fake_set = double("player1's fake passing set")
        @game.stub(:passing_sets_are_ready?).and_return(false)
        @player1.stub(:card_passing_set).and_return(fake_set)
        fake_set.stub(:is_ready).and_return(true)
        @game.waiting_for_others_to_pass?(@player1).should == true
      end
    end
    
    context "another_human_is_next?" do

      it "should not crash" do
        @game.another_human_is_next?(@player2)
      end
    end
    
    context "is_not_current_players_turn?" do

      it "should not crash" do
        @game.is_not_current_players_turn?(@player1)
      end
    end

  end 
  
  describe "#methods" do
    
    context "fill_empty_seats" do
      
      it "should make 4 computer players with no one in the room" do
        expect{ @game.fill_empty_seats }.to change{ @game.players.size }.from(0).to(4)
        @game.players.each do |p|
          p.is_computer?.should == true
        end
      end
    end
    
    context "add_player_from_user(user)" do
      
      it "should add a player if it's not full and doesn't have player already" do
        expect{ @game.add_player_from_user(@user1) }.to change{ @game.reload.players.length }.by(1)
      end
      
      it "should not do anything if player is in game already" do
        @game.add_player_from_user(@user1)
        expect{ @game.add_player_from_user(@user1) }.to_not change{ @game.reload.players.length }
      end
      
      it "should not do anything if game is full" do
        @game.add_player_from_user(@user1)
        @game.add_player_from_user(@user2)
        @game.add_player_from_user(@user3)
        @game.add_player_from_user(@user4)
        @user5 = FactoryGirl.create(:user, :username => "game_user5")
        expect{ @game.add_player_from_user(@user5) }.to_not change{ @game.reload.players.length }
      end
    end
    
    context "create_round" do
      
      before do
        create_players; create_cards
      end
      
      it "should increase round count by 1" do
        expect{ @game.create_round}.to change{ Round.count }.by(1)
      end
    end
    
    context "play_card(card)" do
    
      it "should throw the call to the last trick" do
        card = double("Fake Card")
        my_fake_trick = double("Fake Last Trick")
        @game.stub(:last_trick).and_return(my_fake_trick)
        my_fake_trick.stub(:next_player).and_return(nil)
        my_fake_trick.should_receive(:play_card_from).with(@game.next_player, card)
        @game.play_card(card)
      end
    end
    
    context "is_not_over?" do
      
      it "should return true and false when it has to" do
        @game.is_not_over?.should == true
        @game.update_attributes(:winner_id => 3)
        @game.is_not_over?.should == false
      end
    end
    
    context "previous_trick" do
      
      it "should throw the call to last_round" do
        fake_last_round = double("My Fake Last Round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.should_receive(:try).with(:previous_trick)
        @game.previous_trick
      end
    end
    
    context "update_scores_if_necessary" do
      
      it "should do round scores if trick is over" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(false)
        
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.stub(:is_over?).and_return(true)
        
        fake_last_round.should_receive(:calculate_round_scores)
        fake_last_round.should_not_receive(:update_total_scores)
        @game.should_not_receive(:check_for_and_set_winner)
        
        @game.update_scores_if_necessary
      end
      
      it "should do round and total scores if trick and round is over" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(true)
        
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.stub(:is_over?).and_return(true)
        
        fake_last_round.should_receive(:calculate_round_scores)
        fake_last_round.should_receive(:update_total_scores)
        @game.should_receive(:check_for_and_set_winner)
        
        @game.update_scores_if_necessary  
      end
      
      it "shouldn't do anything if nothing is over" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(false)
        
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.stub(:is_over?).and_return(false)
        
        fake_last_round.should_not_receive(:calculate_round_scores)
        fake_last_round.should_not_receive(:update_total_scores)
        @game.should_not_receive(:check_for_and_set_winner)
        
        @game.update_scores_if_necessary
      end
    end
    
    
    context "present_usernames" do

      before do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      end
      
      it "should return the right array of usernames" do
        @game.send(:present_usernames).should == ["game_user1", "game_user2", "game_user3", "game_user4"]
      end
    end
    
  end

end
