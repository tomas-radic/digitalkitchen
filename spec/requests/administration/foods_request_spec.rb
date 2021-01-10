require 'rails_helper'

RSpec.describe "Administration::Foods", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/administration/foods/index"
      expect(response).to have_http_status(:success)
    end
  end

end
