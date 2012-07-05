require "spec_helper"

describe PlayedTricksController do
  describe "routing" do

    it "routes to #index" do
      get("/played_tricks").should route_to("played_tricks#index")
    end

    it "routes to #new" do
      get("/played_tricks/new").should route_to("played_tricks#new")
    end

    it "routes to #show" do
      get("/played_tricks/1").should route_to("played_tricks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/played_tricks/1/edit").should route_to("played_tricks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/played_tricks").should route_to("played_tricks#create")
    end

    it "routes to #update" do
      put("/played_tricks/1").should route_to("played_tricks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/played_tricks/1").should route_to("played_tricks#destroy", :id => "1")
    end

  end
end
