require "rails_helper"

describe RawPolicy, type: :model do
  subject { Pundit.policy_scope!(user, Raw) }

  let!(:user) do
    create(:user, raws: [
        create(:raw, name: "public raw 1"),
        create(:raw, :onetime, name: "user raw 1")
    ])
  end

  let!(:another_user) do
    create(:user, raws: [
        create(:raw, name: "public raw 2"),
        create(:raw, :onetime, name: "user raw 2")
    ])
  end

  it "Returns only raws visible for user" do
    result = subject

    expect(result.count).to eq(3)
    expect(result.pluck(:name)).to include("public raw 1",
                                           "public raw 2",
                                           "user raw 1")
  end
end
