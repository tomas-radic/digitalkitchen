require 'rails_helper'

RSpec.describe "Raws", type: :request do

  include_examples "coexisting_data"


  let!(:user) { create(:user) }


  describe "GET /raws" do
    subject { get raws_path }

    let(:template) { :index }

    it_behaves_like "authenticated_template_requests"
  end


  describe "POST /raws/:raw_id/switch_ownership" do
    subject { post raw_switch_ownership_path(raw_id: raw.id), xhr: true }

    let!(:raw) { create(:raw) }
    let(:template) { :switch_ownership }

    it_behaves_like "authenticated_xhr_requests"
  end

end
