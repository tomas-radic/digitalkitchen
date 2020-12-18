require "rails_helper"

describe CreateUserRaw, type: :model do
  subject { described_class.call(name, category_id: category.id, user: user) }


  include_examples "coexisting_data"

  let!(:user) { create(:user) }
  let!(:category) { create(:raw_category) }

  let(:another_name) { "another name" }
  let!(:another_user) do
    create(:user, ownerships: [
        create(:ownership, raw: create(:raw, :onetime, name: another_name))
    ])
  end


  context "Creating raw with non-existing name" do
    let(:name) { "user's shopping item" }

    it "Creates onetime raw with ownership for user" do
      result = nil
      expect { result = subject }.to change { Raw.count }.by(1)

      expect(result).to be_a Raw
      expect(result.is_onetime?).to be(true)
      expect(result.raw_category).to eq(category)
      expect(result.ownerships.count).to eq(1)
      expect(result.ownerships.first.user_id).to eq(user.id)
    end
  end


  context "Creating raw with name as existing non-onetime raw" do
    let!(:raw) do
      create(:raw, name: name,
             raw_category: create(:raw_category),
             ownerships: [create(:ownership)])
    end
    let(:name) { "existing raw" }

    context "When user does not have ownership of that existing raw" do
      it "Does not create new raw" do
        expect { subject }.not_to change { Raw.count }
      end

      it "Creates need_buy ownership to that raw for the user" do
        expect { subject }.to change { Ownership.count }.by(1)

        expect(Ownership.order(:created_at).last).to have_attributes(
                                                         user_id: user.id,
                                                         raw_id: raw.id,
                                                         need_buy: true
                                                     )
      end
    end

    context "When user has non need_buy ownership to that existing raw" do
      let!(:ownership) { create(:ownership, user: user, raw: raw, need_buy: false) }

      it "Does not create new raw" do
        expect { subject }.not_to change { Raw.count }
      end

      it "Switches the ownership to need_buy" do
        expect { subject }.not_to change { Ownership.count }

        expect(ownership.reload.need_buy?).to eq(true)
      end
    end

    context "When user has a need_buy ownership to that existing raw" do
      let!(:ownership) { create(:ownership, user: user, raw: raw, need_buy: true) }

      it "Does not create new raw" do
        expect { subject }.not_to change { Raw.count }
      end

      it "Keeps the ownership as is" do
        expect { subject }.not_to change { Ownership.count }

        expect(ownership.reload.need_buy?).to eq(true)
      end
    end

  end


  context "Creating raw with name same as existing onetime raw of another user" do
    let(:name) { another_name }

    it "Creates onetime raw with ownership for user" do
      result = nil
      expect { result = subject }.to change { Raw.count }.by(1)

      expect(result.is_onetime?).to be(true)
      expect(result.raw_category).to eq(category)
      expect(result.ownerships.count).to eq(1)
      expect(result.ownerships.first.user_id).to eq(user.id)
    end
  end


  context "Creating raw with blank name" do
    let(:name) { "" }

    it "Returns unpersisted raw" do
      result = nil
      expect { result = subject }.not_to change { Raw.count }

      expect(result).to be_a(Raw)
      expect(result.persisted?).to be(false)
    end
  end
end
