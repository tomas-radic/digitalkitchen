require 'rails_helper'

RSpec.describe "Ownerships", type: :request do

  include_examples "coexisting_data"


  let!(:user) { create(:user) }

  describe "GET /ownerships" do
    subject { get ownerships_path }

    let(:template) { :index }
    it_behaves_like "authenticated_requests_rendering"
  end


  describe "POST /ownerships" do
    subject { post ownerships_path, params: { ownership: { raw_id: raw.id, need_buy: false } }, xhr: true }

    let!(:raw) { create(:raw) }
    let(:template) { :create }

    it_behaves_like "authenticated_xhr_requests"
  end


  describe "DELETE /ownerships/:id" do
    subject { delete ownership_path(ownership), xhr: true }

    let(:ownership) { create(:ownership, user: user) }
    let(:template) { :destroy }

    it_behaves_like "authenticated_xhr_requests"
  end


  describe "POST /ownerships/:id/switch" do
    subject { post switch_ownership_path(ownership), xhr: true }

    let!(:ownership) { create(:ownership, user: user) }
    let(:template) { :switch_ownership }

    it_behaves_like "authenticated_xhr_requests"
  end


  describe "POST /ownerships/add_all/:food_id" do
    subject { post add_all_ownerships_path(food_id: food.id) }

    let!(:food) { create(:food) }
    let(:redirect_path) { food_path(food) }

    it_behaves_like "authenticated_requests_redirected"
  end


  describe "POST /ownerships/remove_all" do
    subject { post remove_all_ownerships_path }

    let(:redirect_path) { ownerships_path }

    it_behaves_like "authenticated_requests_redirected"
  end
end
