require 'spec_helper'

describe "tricks/show" do
  before(:each) do
    @trick = assign(:trick, stub_model(Trick,
      :leader_id => 1,
      :lead_suit => "Lead Suit",
      :round_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Lead Suit/)
    rendered.should match(/2/)
  end
end
