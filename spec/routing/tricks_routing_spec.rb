require "spec_helper"

describe TricksController do
  describe "routing" do

    it "routes to #index" do
      get("/tricks").should route_to("tricks#index")
    end

    it "routes to #new" do
      get("/tricks/new").should route_to("tricks#new")
    end

    it "routes to #show" do
      get("/tricks/1").should route_to("tricks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tricks/1/edit").should route_to("tricks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tricks").should route_to("tricks#create")
    end

    it "routes to #update" do
      put("/tricks/1").should route_to("tricks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tricks/1").should route_to("tricks#destroy", :id => "1")
    end

  end
end
