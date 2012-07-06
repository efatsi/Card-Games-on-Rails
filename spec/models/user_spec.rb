require 'spec_helper'

describe User do
  
  it "should validate username presence" do
    should validate_presence_of(:username)
  end
  
end