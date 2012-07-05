require "spec_helper"

describe RoundsController do
  describe "routing" do

    it "routes to #index" do
      get("/rounds").should route_to("rounds#index")
    end

    it "routes to #new" do
      get("/rounds/new").should route_to("rounds#new")
    end

    it "routes to #show" do
      get("/rounds/1").should route_to("rounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rounds/1/edit").should route_to("rounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rounds").should route_to("rounds#create")
    end

    it "routes to #update" do
      put("/rounds/1").should route_to("rounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rounds/1").should route_to("rounds#destroy", :id => "1")
    end

  end
end
