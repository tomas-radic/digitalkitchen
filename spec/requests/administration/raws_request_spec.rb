require 'rails_helper'

RSpec.describe "Administration::Raws", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/administration/raws/index"
      expect(response).to have_http_status(:success)
    end
  end

end
