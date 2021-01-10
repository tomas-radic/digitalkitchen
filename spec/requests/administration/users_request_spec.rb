require 'rails_helper'

RSpec.describe "Administration::Users", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/administration/users/index"
      expect(response).to have_http_status(:success)
    end
  end

end
