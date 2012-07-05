require 'spec_helper'

describe "rounds/show" do
  before(:each) do
    @round = assign(:round, stub_model(Round,
      :dealer_id => 1,
      :room_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
