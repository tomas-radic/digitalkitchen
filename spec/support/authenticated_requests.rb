shared_examples "authenticated_template_requests" do
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

      expect(response).to redirect_to new_user_session_path
    end
  end
end

shared_examples "authenticated_redirected_requests" do
  context "With user signed in" do
    before { sign_in user }

    it "Renders template" do
      subject

      expect(response).to redirect_to(redirect_path)
    end
  end

  context "Without user signed in" do
    it "Redirects to login" do
      subject

      expect(response).to redirect_to new_user_session_path
    end
  end
end


shared_examples "authenticated_xhr_requests" do
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
