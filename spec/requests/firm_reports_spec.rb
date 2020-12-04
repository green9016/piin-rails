require 'rails_helper'

RSpec.describe "FirmReports", type: :request do
  describe "GET /firm_reports" do
    it "works! (now write some real specs)" do
      get firm_reports_path
      expect(response).to have_http_status(200)
    end
  end
end
