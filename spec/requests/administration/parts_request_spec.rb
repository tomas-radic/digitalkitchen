require 'rails_helper'

RSpec.describe "Administration::Parts", type: :request do

  describe "GET /edit" do
    it "returns http success" do
      get "/administration/parts/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
