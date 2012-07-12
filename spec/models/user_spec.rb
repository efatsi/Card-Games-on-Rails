require 'spec_helper'

describe User do

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  before do
    @spades_room = FactoryGirl.create(:room, :game_type => "Spades")
    @spades_game = @spades_room.game
    @spades_round = SpadesRound.create(:game_id => @spades_game.id, :dealer_index => 0)
    @user = FactoryGirl.create(:user, :username => "user_user", :game_id => @spades_game.id)
  end

  it "should know it is a user" do
    @user.should be_an_instance_of User
  end

  context "with a dealt out deck" do

    before do
      @spades_round.deal_cards
    end

    it "should have 13 cards in hand" do
      @user.hand.length.should == 13
    end

  end

  context "with a hand full of clubs" do

    before do
      %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
        FactoryGirl.create(:card, :suit => "club", :value => value, :card_owner => @user)
      end
    end

    it "should have 13 cards in hand" do
      @user.hand.length.should == 13
    end

    it "should only_have? clubs" do
      @user.only_has?("club").should == true
      @user.only_has?("heart").should == false
      @user.only_has?("spade").should == false
      @user.only_has?("diamond").should == false
    end
    
    it "should have_none_of all the other suits" do
      @user.has_none_of?("club").should == false
      @user.has_none_of?("heart").should == true
      @user.has_none_of?("spade").should == true
      @user.has_none_of?("diamond").should == true
    end
  end
  
  context "with a few tricks won" do
    
    before do
      %w(3 8 K).each do |value|
        played_trick = FactoryGirl.create(:played_trick, :user_id => @user.id)
        %w(club heart spade diamond).each do |suit|
          card = FactoryGirl.create(:card, :suit => suit, :value => value, :card_owner => played_trick)
        end
      end
    end
    
    it "should know user has 3 played_tricks" do
      @user.played_tricks.length.should == 3
    end
    
    it "should know how big the round_collection is" do
      @user.round_collection.length.should == 3*4
    end
    
  end
  
  context "with a bunch of stats tacked up" do
    
    before do
      @user.total_score = 40
      @user.round_score = 10923
      @user.bid         = 5
      @user.going_nil   = true
      @user.going_blind = true
      @user.save
    end
    
    it "should reset all the values with reset_for_new_game" do
      @user.total_score.should_not == 0
      @user.round_score.should_not == 0
      @user.bid.should_not == 0
      @user.going_nil.should_not == false
      @user.going_blind.should_not == false
      
      @user.reset_for_new_game
      
      @user.total_score.should == 0
      @user.round_score.should == 0
      @user.bid.should == 0
      @user.going_nil.should == false
      @user.going_blind.should == false
    end
  end

end