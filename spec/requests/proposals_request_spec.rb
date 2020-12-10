require 'rails_helper'

RSpec.describe "Proposals", type: :request do

  include_examples "coexisting_data"


  let!(:user) { create(:user) }

  describe "GET /proposals" do
    subject { get proposals_path }

    let(:template) { :index }

    it_behaves_like "authenticated_template_requests"
  end


  describe "GET /proposals/new" do
    subject { get new_proposal_path }

    let(:template) { :new }

    it_behaves_like "authenticated_template_requests"
  end


  describe "POST /proposals" do
    subject { post proposals_path, params: params }

    context "With correct params" do
      let(:params) do
        { proposal: { name: "Name", ingredients: "ingredients", description: "description" } }
      end

      let(:redirect_path) { foods_path }

      it_behaves_like "authenticated_redirected_requests"
    end

    context "With incorrect params" do
      let(:params) do
        { proposal: { name: "", ingredients: "ingredients", description: "description" } }
      end

      before { sign_in user }

      it "Renders new template" do
        expect(subject).to render_template(:new)
      end
    end
  end


  describe "GET /proposals/:id/edit" do
    subject { get edit_proposal_path(proposal) }

    let!(:proposal) { create(:proposal, user: user) }
    let(:template) { :edit }

    it_behaves_like "authenticated_template_requests"

    context "With proposal id of different user" do
      before do
        proposal.update(user: create(:user))
        sign_in user
      end

      it "Raises error" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end


  describe "PUT /proposals/:id" do
    subject { put proposal_path(proposal), params: params }

    let!(:proposal) { create(:proposal, user: user) }

    context "With correct params" do
      let(:params) do
        { proposal: { name: "changed name" } }
      end
      let(:redirect_path) { foods_path }

      it_behaves_like "authenticated_redirected_requests"
    end

    context "With incorrect params" do
      let(:params) do
        { proposal: { name: "" } }
      end

      before { sign_in user }

      it "Renders edit template" do
        subject

        expect(response).to render_template(:edit)
      end
    end

    context "With correct params but proposal id of different user" do
      let(:params) do
        { proposal: { name: "changed name" } }
      end

      before do
        proposal.update(user: create(:user))
        sign_in user
      end

      it "Raises error" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end


  describe "DELETE /proposals/:id" do
    subject { delete proposal_path(proposal) }

    let!(:proposal) { create(:proposal, user: user) }
    let(:redirect_path) { foods_path }

    it_behaves_like "authenticated_redirected_requests"

    context "With signed in user" do
      before { sign_in user }

      it "Destroys the proposal" do
        expect { subject }.to change { Proposal.count }.by(-1)
      end
    end

    context "With proposal id of different user" do
      before do
        proposal.update(user: create(:user))
        sign_in user
      end

      it "Raises error" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

end
