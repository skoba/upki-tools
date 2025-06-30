require 'rails_helper'

RSpec.describe "BatchRevocations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/batch_revocation/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/batch_revocation/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
