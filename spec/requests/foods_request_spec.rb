require 'rails_helper'

RSpec.describe "Foods", type: :request do

  include_examples "coexisting_data"


  describe "/foods" do
    subject { get foods_path }

    it "Renders index template" do
      subject

      expect(response).to render_template(:index)
    end

    context "With filter" do
      pending "Add some examples"
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


  describe "/foods/:food_id/switch_ownership/:raw_id" do
    subject { post food_switch_ownership_path(food_id: food.id, raw_id: raw.id), xhr: true }

    let!(:user) { create(:user) }
    let!(:food) { create(:food) }
    let!(:raw) { create(:raw) }
    let!(:template) { :switch_ownership }

    it_behaves_like "authenticated_requests"

    context "When food is inaccessible to user" do
      before do
        food.update(owner_private: true)
        sign_in user
      end

      it "Raises error" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
