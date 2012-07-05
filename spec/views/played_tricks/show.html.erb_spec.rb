require 'spec_helper'

describe "played_tricks/show" do
  before(:each) do
    @played_trick = assign(:played_trick, stub_model(PlayedTrick,
      :size => 1,
      :trick_owner_type => "Trick Owner Type",
      :trick_owner_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Trick Owner Type/)
    rendered.should match(/2/)
  end
end
