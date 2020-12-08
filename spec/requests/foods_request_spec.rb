require 'rails_helper'

RSpec.describe "Foods", type: :request do
  describe "/foods" do
    subject { get foods_path }

    it "Renders index template" do
      subject

      expect(response).to render_template(:index)
    end
  end


  describe "/foods/:id" do
    subject { get food_path(food) }

    let!(:food) { create(:food) }

    it "Renders show template" do
      subject

      expect(response).to render_template(:show)
    end

    context "With food not publicly accessible" do
      let!(:food) { create(:food, :owner_private) }

      it "Raises error" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context "With user logged in" do
        let!(:user) { create(:user) }
        before { sign_in user }

        context "And food owned by logged in user" do
          before { food.update(owner: user) }

          it "Renders show template" do
            subject

            expect(response).to render_template(:show)
          end
        end

        context "And food owned by other user" do
          it "Raises error" do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
