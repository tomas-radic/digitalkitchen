require 'rails_helper'

RSpec.describe AvailableFoods, type: :model do
  subject { described_class.call(user) }

  let!(:raw1) { create(:raw) }
  let!(:raw2) { create(:raw) }
  let!(:raw3) { create(:raw) }
  let!(:raw4) { create(:raw) }

  let!(:user) { create(:user) }

  # Food 1 - must have raw1 and raw2
  let!(:food1) do
    create(:food,
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
    create(:food,
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
    create(:food,
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


  let!(:food4) do
    create(:food, :owner_private,
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

  before do
    user.raws << raw1 << raw2 << raw3
  end

  it "Returns foods available for given user based on owned raws" do
    result = subject

    expect(result.count).to eq(2)
    expect(result).to include(food1, food2)
  end
end
