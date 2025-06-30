require 'rails_helper'

RSpec.describe "Certificates", type: :request do
  describe "GET /certificates" do
    it "works! (now write some real specs)" do
      get certificates_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'new' do
    it 'fills default parameters from profile'

    it 'accepts cn, operator name, organization, email, software'
    it 'returns zip file of tsv and private key'
  end
end
