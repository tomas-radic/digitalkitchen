require 'rails_helper'

RSpec.describe "Raws", type: :request do

  include_examples "coexisting_data"


  let!(:user) { create(:user) }


  describe "GET /raws" do
    subject { get raws_path }

    let(:template) { :index }

    it_behaves_like "authenticated_template_requests"
  end


  describe "POST /raws" do
    subject { post raws_path, params: params, xhr: true }

    let(:template) { :create }
    let(:params) do
      { raw: { name: "name", category_id: "abc" } }
    end

    it_behaves_like "authenticated_xhr_requests"

    context "With authenticated user" do
      before { sign_in user }

      it "Calls service object with correct parameters" do
        expect(CreateUserRaw).to receive(:call).with(
            params[:raw][:name],
            category_id: params[:raw][:category_id],
            user: user)

        subject
      end
    end
  end


  describe "POST /raws/:raw_id/switch_ownership" do
    subject { post raw_switch_ownership_path(raw_id: raw.id), xhr: true }

    let!(:raw) { create(:raw) }
    let(:template) { :switch_ownership }

    it_behaves_like "authenticated_xhr_requests"
  end


  describe "POST /raws/create_ownership" do
    subject { post create_ownership_raws_path, params: { ownership: { raw_id: raw.id, need_buy: false } }, xhr: true }

    let!(:raw) { create(:raw) }
    let(:template) { :create_ownership }

    it_behaves_like "authenticated_xhr_requests"
  end




end
