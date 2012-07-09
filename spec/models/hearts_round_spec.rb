require 'spec_helper'

describe HeartsRound do

  before :all do
    @hearts = HeartsGame.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user2 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user3 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user4 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @hearts_round = HeartsRound.create(:game_id => @hearts.id, :dealer_index => 0)
    @deck = @hearts_round.deck
    @players = @hearts_round.players
  end

  after :all do
    Card.delete_all
    Game.delete_all
    Round.delete_all
    User.delete_all
    Deck.delete_all
    PlayedTrick.delete_all   
  end

  describe "#setup" do

    context "#new_hearts_round" do

      it "should show that round has been initiated" do
        @hearts_round.should be_an_instance_of HeartsRound
      end
      
      it "should know that hearts have not been broken yet" do
        @hearts_round.hearts_broken.should == false
      end

    end

  end
  
  describe "#passing" do
    
    context "pass_cards" do
      
      before :each do
        @hearts_round.deal_cards
      end

      after :each do
        @hearts_round.return_cards
      end
      
      it "should leave all players with 13 cards still" do
        @hearts_round.pass_cards("right")
        @players.each {|p| p.hand.length.should == 13 }
      end
      it "should leave players with 3 new cards" do
        old_hand = [] + @user1.hand
        @hearts_round.pass_cards("across")
        new_hand = [] + @user1.hand
        new_card_count = 0
        new_hand.each do |card|
          new_card_count += 1 unless old_hand.include?(card)
        end
        new_card_count.should == 3
      end
      
    end
    
  end
  
  describe "#scoring" do
    
    context "shared_collection_round" do
      
      before :each do
        13.times do |i|
          trick = PlayedTrick.create(:size => 4)
          4.times do |j|
            card = @deck.cards.first
            card.card_owner = trick
            card.save
          end
          trick.user_id = (rand < 0.5 ? @user1.id : @user2.id)
          trick.save
        end
      end
      
      after :each do
        @hearts_round.return_cards
        @hearts.reset_scores
      end
      
      it "round_score should count 26" do
        @user1.played_tricks(true)
        # raise @user1.played_tricks.length.inspect
        @hearts_round.update_round_scores
        all_round_scores = 0
        @players.each {|p| all_round_scores += p.round_score }
        all_round_scores.should == 26
      end
      
      it "total_score should count 26" do
        @hearts_round.update_total_scores
        all_total_scores = 0
        @players.each do |p|
          all_total_scores += p.total_score
        end
        all_total_scores.should == 26
      end
      
    end
    
    context "swept_round" do
      
      before :each do
        13.times do |i|
          trick = PlayedTrick.create(:size => 4)
          4.times do |j|
            card = @deck.cards.first
            card.card_owner = trick
            card.save
          end
          trick.user_id = @user1.id
          trick.save
        end
      end
      
      after :each do
        @hearts_round.return_cards
        @hearts.reset_scores
      end
      
      it "round_score should count 26" do
        @hearts_round.update_round_scores
        all_round_scores = 0
        @players.each {|p| all_round_scores += p.round_score }
        all_round_scores.should == 26
      end
      
      it "total_score should count 26*3" do
        @hearts_round.update_total_scores
        all_total_scores = 0
        @players.each {|p| all_total_scores += p.total_score }
        all_total_scores.should == 26*3
      end
      
    end
  
  end

  describe "#play_round" do
    
    it "should_work" do
      @hearts_round.play_round
    end
    
  end

end
