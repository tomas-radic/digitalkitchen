require 'rails_helper'

RSpec.describe "Foods", type: :request do





  describe "GET /foods" do
    subject { get foods_path, params: params }

    #
    # Data

    let!(:user) { create(:user) }
    let!(:seafood) { create(:food_category, name: "Seafood") }

    # Existing foods
    let!(:food_public) { create(:food,
                                owner: user,
                                name: "food_public") }
    let!(:shrimps_public) { create(:food,
                                   name: "Food1 with shrimps",
                                   food_category: seafood) }
    let!(:shrimps_user_private) { create(:food, :owner_private,
                                         owner: user,
                                         name: "Shrímps in food2",
                                         food_category: seafood) }
    let!(:food_private_foreign) { create(:food, :owner_private,
                                         name: "food_private_foreign") }

    let(:params) { Hash.new }
    let(:limit) { 30 }


    #
    # Test cases

    context "User NOT signed in" do
      it "Assigns foods correctly" do
        subject

        expect(assigns(:foods).length).to eq(2)
        expect(assigns(:foods)).to include(food_public, shrimps_public)
      end

      it "Assigns heading and other variables" do
        subject

        expect(assigns(:heading)).to eq("Všetky jedlá")
        expect(assigns(:limit)).to eq(limit)
        expect(assigns(:total_count)).to eq(2)
      end

      context "Filtered by category" do
        let(:params) do
          { filter: { list: seafood.id } }
        end

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(1)
          expect(assigns(:foods)).to include(shrimps_public)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq(seafood.name)
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(1)
        end

        context "With \"available\" option" do
          let(:params) do
            { filter: { list: seafood.id, available: "true" } }
          end

          it "Assigns foods correctly" do
            expect(AvailableFoods).not_to receive(:call)
            subject

            expect(assigns(:foods).length).to eq(1)
            expect(assigns(:foods)).to include(shrimps_public)
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq(seafood.name)
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(1)
          end
        end
      end

      context "Filtered by \"My Foods\" list" do
        let(:params) do
          { filter: { list: "mine" } }
        end

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(2)
          expect(assigns(:foods)).to include(food_public, shrimps_public)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq("Všetky jedlá")
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(2)
        end

        context "With \"available\" option" do
          let(:params) do
            { filter: { list: "mine", available: "true" } }
          end

          it "Assigns foods correctly" do
            expect(AvailableFoods).not_to receive(:call)

            subject

            expect(assigns(:foods).length).to eq(2)
            expect(assigns(:foods)).to include(food_public, shrimps_public)
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Všetky jedlá")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(2)
          end
        end
      end

      context "Filtered by \"Liked\" list" do
        let(:params) do
          { filter: { list: "liked" } }
        end

        pending "Add examples after liked list has been implemented"
      end

      context "Filtered by accented searched text" do
        let(:params) do
          { filter: { search: "shrí" } }
        end

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(1)
          expect(assigns(:foods)).to include(shrimps_public)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq("Výsledky hľadania")
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(1)
        end

        context "With params that are ignored when searching" do
          let(:params) do
            { filter: { search: "shrí", list: "mine", available: "true" } }
          end

          it "Assigns foods correctly" do
            subject

            expect(assigns(:foods).length).to eq(1)
            expect(assigns(:foods)).to include(shrimps_public)
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Výsledky hľadania")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(1)
          end
        end

        context "Searching unavailable publicly" do
          let(:params) do
            { filter: { search: "food_private_foreign" } }
          end

          it "Assigns foods correctly" do
            subject

            expect(assigns(:foods).length).to eq(0)
            expect(assigns(:foods)).to be_empty
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Výsledky hľadania")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(0)
          end
        end

        context "Searching by two words" do
          let(:params) do
            { filter: { search: "HRIM ághéTT" } }
          end

          let!(:spaghetti) { create(:food, name: "Spaghetti Carbonara") }

          it "Assigns foods correctly" do
            subject

            expect(assigns(:foods).length).to eq(2)
            expect(assigns(:foods)).to include(shrimps_public, spaghetti)
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Výsledky hľadania")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(2)
          end
        end
      end

      context "Filtered by unaccented searched text" do
        let(:params) do
          { filter: { search: "spag" } }
        end

        let!(:spaghetti) { create(:food, name: "Špagety") }

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(1)
          expect(assigns(:foods)).to include(spaghetti)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq("Výsledky hľadania")
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(1)
        end
      end
    end

    context "User signed in" do
      before { sign_in user }

      it "Assigns foods correctly" do
        subject

        expect(assigns(:foods).length).to eq(3)
        expect(assigns(:foods)).to include(food_public, shrimps_public, shrimps_user_private)
      end

      it "Assigns heading and other variables" do
        subject

        expect(assigns(:heading)).to eq("Všetky jedlá")
        expect(assigns(:limit)).to eq(limit)
        expect(assigns(:total_count)).to eq(3)
      end

      it "Assigns heading and other variables" do
        subject

        expect(assigns(:heading)).to eq("Všetky jedlá")
        expect(assigns(:limit)).to eq(limit)
        expect(assigns(:total_count)).to eq(3)
      end

      it "Assigns heading and other variables" do
        subject

        expect(assigns(:heading)).to eq("Všetky jedlá")
        expect(assigns(:limit)).to eq(limit)
        expect(assigns(:total_count)).to eq(3)
      end

      context "Filtered by category" do
        let(:params) do
          { filter: { list: seafood.id } }
        end

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(2)
          expect(assigns(:foods)).to include(shrimps_public, shrimps_user_private)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq(seafood.name)
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(2)
        end

        context "With \"available\" option" do
          let(:params) do
            { filter: { list: seafood.id, available: "true" } }
          end

          it "Assigns foods correctly" do
            expect(AvailableFoods).to(
                receive(:call).and_return(Food.none)
            )

            subject

            expect(assigns(:foods).length).to eq(0)
            expect(assigns(:foods)).to be_empty
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq(seafood.name)
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(0)
          end
        end
      end

      context "Filtered by \"My Foods\" list" do
        let(:params) do
          { filter: { list: "mine" } }
        end

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(2)
          expect(assigns(:foods)).to include(food_public, shrimps_user_private)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq("Moje jedlá")
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(2)
        end

        context "With \"available\" option" do
          let(:params) do
            { filter: { list: "mine", available: "true" } }
          end

          it "Assigns foods correctly" do
            expect(AvailableFoods).to(
                receive(:call).and_return(Food.none)
            )

            subject

            expect(assigns(:foods).length).to eq(0)
            expect(assigns(:foods)).to be_empty
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Moje jedlá")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(0)
          end
        end
      end

      context "Filtered by \"Liked\" list" do
        let(:params) do
          { filter: { list: "liked" } }
        end

        pending "Add examples after liked list has been implemented"
      end

      context "Filtered by accented searched text" do
        let(:params) do
          { filter: { search: "shrí" } }
        end

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(2)
          expect(assigns(:foods)).to include(shrimps_public, shrimps_user_private)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq("Výsledky hľadania")
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(2)
        end

        context "With params that are ignored when searching" do
          let(:params) do
            { filter: { search: "shrí", list: "mine", available: "true" } }
          end

          it "Assigns foods correctly" do
            expect(AvailableFoods).not_to receive(:call)

            subject

            expect(assigns(:foods).length).to eq(2)
            expect(assigns(:foods)).to include(shrimps_public)
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Výsledky hľadania")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(2)
          end
        end

        context "Searching unavailable for user signed in" do
          let(:params) do
            { filter: { search: "food_private_foreign" } }
          end

          it "Assigns foods correctly" do
            subject

            expect(assigns(:foods).length).to eq(0)
            expect(assigns(:foods)).to be_empty
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Výsledky hľadania")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(0)
          end
        end

        context "Searching by two words" do
          let(:params) do
            { filter: { search: "HRIM ághéTT" } }
          end

          let!(:spaghetti) { create(:food, name: "Spaghetti Carbonara") }

          it "Assigns foods correctly" do
            subject

            expect(assigns(:foods).length).to eq(3)
            expect(assigns(:foods)).to include(shrimps_public, shrimps_user_private, spaghetti)
          end

          it "Assigns heading and other variables" do
            subject

            expect(assigns(:heading)).to eq("Výsledky hľadania")
            expect(assigns(:limit)).to eq(limit)
            expect(assigns(:total_count)).to eq(3)
          end
        end
      end

      context "Filtered by unaccented searched text" do
        let(:params) do
          { filter: { search: "spag" } }
        end

        let!(:spaghetti) { create(:food, name: "Špagety") }

        it "Assigns foods correctly" do
          subject

          expect(assigns(:foods).length).to eq(1)
          expect(assigns(:foods)).to include(spaghetti)
        end

        it "Assigns heading and other variables" do
          subject

          expect(assigns(:heading)).to eq("Výsledky hľadania")
          expect(assigns(:limit)).to eq(limit)
          expect(assigns(:total_count)).to eq(1)
        end
      end
    end

    it "Renders index template" do
      subject

      expect(response).to render_template(:index)
    end
  end


  describe "GET /foods/:id" do
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


  describe "POST /foods/:food_id/switch_ownership/:raw_id" do
    subject { post food_switch_ownership_path(food_id: food.id, raw_id: raw.id), xhr: true }

    let!(:user) { create(:user) }
    let!(:food) { create(:food) }
    let!(:raw) { create(:raw) }
    let!(:template) { :switch_ownership }

    it_behaves_like "authenticated_xhr_requests"

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
