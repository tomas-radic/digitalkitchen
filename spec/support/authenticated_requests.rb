shared_examples "authenticated_requests" do
  context "With user signed in" do
    before { sign_in user }

    it "Renders template" do
      subject

      expect(response).to render_template(template)
    end
  end

  context "Without user signed in" do
    it "Redirects to login" do
      subject

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
