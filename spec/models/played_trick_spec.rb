require 'spec_helper'

describe PlayedTrick do
  
  before do
    @user = FactoryGirl.create(:user, :username => "played_trick_user")
    @played_trick = FactoryGirl.create(:played_trick, :user_id => @user.id)
    %w(club heart spade diamond).each do |suit|
      card = FactoryGirl.create(:card, :suit => suit, :value => "2", :card_owner => @played_trick)
    end
  end
  
  it { should have_many(:cards) }
  
  it "should know it is a played trick" do
    @played_trick.should be_an_instance_of PlayedTrick
  end
  
  it "should know it has 4 cards" do
    @played_trick.cards.length.should == 4
  end
  
  it "should know which user it belongs to" do
    @played_trick.player.should == @user
  end
  
  it "user should know about it's played_trick" do
    @user.played_tricks.length.should == 1
    @user.played_tricks.first.should == @played_trick
  end  
  
end
