require 'rails_helper'

RSpec.describe AvailableFoods, type: :model do
  subject { described_class.call(user: user, foods: Food.all) }

  let!(:raw1) { create(:raw) }
  let!(:raw2) { create(:raw) }
  let!(:raw3) { create(:raw) }
  let!(:raw4) { create(:raw) }

  let!(:user) { create(:user) }

  # Food 1 - must have raw1 and raw2
  let!(:food1) do
    create(:food, name: "Food 1",
           parts: [
               build(:part, position: 1,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw1),
                               ]
                         ),
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw2)
                               ]
                         )
                     ]
               )
           ]
    )
  end

  # Food 2 - must have raw1 and raw2 and (raw3 or raw4)
  let!(:food2) do
    create(:food, name: "Food 2",
           parts: [
               build(:part, position: 1,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw1)
                               ]
                         ),
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw2)
                               ]
                         )
                     ]
               ),
               build(:part, position: 2,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw3),
                                   build(:alternative, raw: raw4)
                               ]
                         )
                     ]
               )
           ]
    )
  end

  # Food 3 - must have raw1 and raw2 and raw4
  let!(:food3) do
    create(:food, name: "Food 3",
           parts: [
               build(:part, position: 1,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw1)
                               ]
                         ),
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw2)
                               ]
                         )
                     ]
               ),
               build(:part, position: 2,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw4)
                               ]
                         )
                     ]
               )
           ]
    )
  end

  # Food 4 - must have raw1 and raw2, but food is private for its owner
  let!(:food4) do
    create(:food, :owner_private, name: "Food 4",
           parts: [
               build(:part, position: 1,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw1),
                               ]
                         ),
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw2)
                               ]
                         )
                     ]
               )
           ]
    )
  end

  # Food 5 - must have raw1 and optionally to have raw4
  let!(:food5) do
    create(:food, name: "Food 5",
           parts: [
               build(:part, position: 1,
                     ingredients: [
                         build(:ingredient,
                               alternatives: [
                                   build(:alternative, raw: raw1),
                               ]
                         ),
                         build(:ingredient, :optional,
                               alternatives: [
                                   build(:alternative, raw: raw4)
                               ]
                         )
                     ]
               )
           ]
    )
  end

  before do
    user.ownerships.create!(raw: raw1, need_buy: false)
    user.ownerships.create!(raw: raw2, need_buy: false)
    user.ownerships.create!(raw: raw3, need_buy: false)
    user.ownerships.create!(raw: raw4, need_buy: true)
  end

  it "Returns foods available for given user based on owned raws" do
    result = subject

    expect(result.count).to eq(3)
    expect(result).to include(food1, food2, food5)
  end
end
