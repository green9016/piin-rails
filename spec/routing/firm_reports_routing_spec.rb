require "rails_helper"

RSpec.describe FirmReportsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/firm_reports").to route_to("firm_reports#index")
    end

    it "routes to #show" do
      expect(:get => "/firm_reports/1").to route_to("firm_reports#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/firm_reports").to route_to("firm_reports#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/firm_reports/1").to route_to("firm_reports#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/firm_reports/1").to route_to("firm_reports#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/firm_reports/1").to route_to("firm_reports#destroy", :id => "1")
    end
  end
end
