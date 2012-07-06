require 'spec_helper'

describe Round do

  before :all do
    @game = Game.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @game.id)
    @user2 = FactoryGirl.create(:user, :game_id => @game.id)
    @user3 = FactoryGirl.create(:user, :game_id => @game.id)
    @user4 = FactoryGirl.create(:user, :game_id => @game.id)
    @round = Round.create(:game_id => @game.id, :dealer_index => 0)
    @deck = @round.deck
    @players = @round.players
  end

  after :all do
    Game.delete_all
    Round.delete_all
    User.delete_all
    Deck.delete_all    
  end

  describe "#setup" do

    context "#new_round" do

      it "should show that round has been initiated" do
        @round.should be_an_instance_of Round
      end

    end

  end

  describe "#methods" do

    context "#new_dealer_id" do

      before :all do
        @round.dealer_index = 3
      end

      it "should work" do
        @round.new_dealer_index.should == 0
      end

    end

    context "#deal_cards" do

      it "should work" do
        @round.deal_cards
        @players.each do |player|
          player.hand.length.should == 13
          player.hand.first.should be_an_instance_of Card
        end
      end

    end

    context "#return_cards" do

      before :each do
        Card.all.each do |card|
          card.card_owner_type = "Deck"
          card.card_owner_id = @deck.id
        end
        @round.deal_cards
      end

      it "should work" do
        @players.each {|p| p.hand.length.should == 13 }
        @round.return_cards
        @players.each do |p| 
          p.cards(true)
          p.hand.length.should == 0
        end

      end
    end
    context "#players" do

      it "should work" do
        @players.length.should == 4
        @players.each do |p|
          p.should be_instance_of User
        end
      end

    end
    context "#dealer" do

      it "should work" do
        @round.dealer_index = @players.index(@user2)
        @round.dealer_index = @players.index(@user3)
        @round.dealer.should == @user3
      end

    end
    context "#get_leader_index" do

      before :each do
        give_two_of_clubs_to_user3
      end

      it "before any trick is played" do
        @round.get_leader_index.should == @players.index(@user1)
      end

      it "after a trick has been played" do
        trick = double("my trick")
        trick.stub(:trick_winner_index).and_return(@players.index(@user2))
        @round.stub(:tricks).and_return([trick])

        @round.get_leader_index.should == @players.index(@user2)
      end

    end
    context "#tricks" do

      it "before any trick is played" do
        @round.tricks_played.should == 0
        @round.last_trick.should == nil
      end

      it "after a trick is played" do
        @new_trick = Trick.create(:round_id => @round.id)
        @round.tricks(true).length.should == 1
        @round.last_trick.should == @new_trick
      end

    end

    context "#card_manipulating" do

      before :each do
        give_two_of_clubs_to_user3
      end
      
      after :each do
        @round.return_cards
      end

      it "deal_card_to_player should work" do
        @user3.hand.include?(@card).should == true
      end

      it "return_card_to_deck" do
        @round.return_card_to_deck(@card)
        @user3.hand.include?(@card).should == false
        @round.deck.cards.include?(@card).should == true
      end

    end

    context "#two_of_clubs_owner_index" do

      before :each do
        @round.return_cards
        give_two_of_clubs_to_user3
      end

      it "should work" do
        @round.two_of_clubs_owner_index.should == @players.index(@user3)
      end

    end

  end

  def give_two_of_clubs_to_user3
    @card = FactoryGirl.create(:card)
    @round.deal_card_to_player(@card, @user3)
  end

end



