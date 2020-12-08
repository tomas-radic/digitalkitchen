require "rails_helper"

describe FoodPolicy, type: :model do
  subject { Pundit.policy_scope!(user, Food) }

  let!(:user) do
    create(:user, foods: [
        create(:food, name: "User public food"),
        create(:food, :owner_private, name: "User private food")
    ])
  end

  let!(:another_user) do
    create(:user, foods: [
        create(:food, name: "Another public food"),
        create(:food, :owner_private, name: "Another private food")
    ])
  end

  it "Returns only foods visible for user" do
    result = subject

    expect(result.count).to eq(3)
    expect(result.pluck(:name)).to include(
                                       "User public food",
                                       "User private food",
                                       "Another public food")
  end
end
