require 'spec_helper'

describe Deck do
  
  before do
    @game = FactoryGirl.create(:game)
    @deck = FactoryGirl.create(:deck, :game_id => @game.id)
  end
  
  it "should be a deck" do
    @deck.should be_an_instance_of Deck
  end
  
  it "should have already filled itself with cards" do
    @deck.reload.cards.length.should == 52
  end
  
  it "should know about it's parent game" do
    @deck.game.should == @game
  end
  
  it "game should know about it's deck" do
    @game.reload.deck.should == @deck
  end
  
end