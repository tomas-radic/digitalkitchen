require 'rails_helper'

describe ArrangedRaws, type: :model do
  subject { described_class.call(food) }

  let!(:category1) { create(:raw_category, name: "C1") }
  let!(:category2) { create(:raw_category, name: "C2") }
  let!(:raw1) { create(:raw, name: "R1", raw_category: category1) }
  let!(:raw2) { create(:raw, name: "R2", raw_category: category1) }
  let!(:raw3) { create(:raw, name: "R3") }
  let!(:raw4) { create(:raw, name: "R4") }
  let!(:raw5) { create(:raw, name: "R5", raw_category: category2) }
  let!(:raw6) { create(:raw, name: "R6", raw_category: category2) }
  let!(:food) do
    create(:food,
           parts: [
               build(:part,
                      ingredients: [
                          build(:ingredient,
                                 alternatives: [
                                     build(:alternative, raw: raw1)
                                 ]),
                          build(:ingredient,
                                 alternatives: [
                                     build(:alternative, raw: raw2)
                                 ])
                      ]),
               build(:part,
                      ingredients: [
                          build(:ingredient,
                                 alternatives: [
                                     build(:alternative, raw: raw1)
                                 ]),
                          build(:ingredient,
                                 alternatives: [
                                     build(:alternative, raw: raw3)
                                 ]),
                          build(:ingredient, :optional,
                                 alternatives: [
                                     build(:alternative, raw: raw2)
                                 ]),
                          build(:ingredient,
                                 alternatives: [
                                     build(:alternative, raw: raw2, position: 1),
                                     build(:alternative, raw: raw5, position: 2)
                                 ])
                      ]),
               build(:part,
                      ingredients: [
                          build(:ingredient,
                                 alternatives: [
                                     build(:alternative, raw: raw1, position: 1),
                                     build(:alternative, raw: raw3, position: 2)
                                 ]),
                          build(:ingredient, :optional,
                                 alternatives: [
                                     build(:alternative, raw: raw1, position: 1),
                                     build(:alternative, raw: raw4, position: 2)
                                 ]),
                          build(:ingredient, :optional,
                                alternatives: [
                                    build(:alternative, raw: raw6)
                                ])
                      ])
           ])
  end

  it "Returns hash describing raws in categories needed for given food" do
    result = subject

    expect(result).to be_a(Hash)
    expect(result.length).to eq(3)
    expect(result.keys).to include(nil, "C1", "C2")

    expect(result[nil]).to be_an Array
    expect(result[nil].length).to eq(1)
    expect(result[nil]).to include(
                               {
                                   raw_id: raw3.id, raw_name: raw3.name, category_name: nil, optional: false
                               }
                           )
    expect(result[category1.name]).to be_an Array
    expect(result[category1.name].length).to eq(5)
    expect(result[category1.name]).to include(
                                     {
                                         raw_id: raw1.id, raw_name: raw1.name, category_name: category1.name, optional: false
                                     },
                                     {
                                         raw_id: raw2.id, raw_name: raw2.name, category_name: category1.name, optional: false
                                     },
                                     [
                                         {
                                             raw_id: raw2.id, raw_name: raw2.name, category_name: category1.name, optional: false
                                         },
                                         {
                                             raw_id: raw5.id, raw_name: raw5.name, category_name: category1.name, optional: false
                                         }
                                     ],
                                     [
                                         {
                                             raw_id: raw1.id, raw_name: raw1.name, category_name: category1.name, optional: false
                                         },
                                         {
                                             raw_id: raw3.id, raw_name: raw3.name, category_name: category1.name, optional: false
                                         }
                                     ],
                                     [
                                         {
                                             raw_id: raw1.id, raw_name: raw1.name, category_name: category1.name, optional: true
                                         },
                                         {
                                             raw_id: raw4.id, raw_name: raw4.name, category_name: category1.name, optional: true
                                         }
                                     ]
                                 )
    expect(result[category2.name]).to be_an Array
    expect(result[category2.name].length).to eq(1)
    expect(result[category2.name]).to include(
                                     {
                                         raw_id: raw6.id, raw_name: raw6.name, category_name: category2.name, optional: true
                                     })
  end
end
