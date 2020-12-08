shared_examples "coexisting_data" do
  describe "Coexisting data" do

    let!(:user1) do
      create(:user, foods: [
          create(:food, parts: [
              build(:part, position: 1,
                    ingredients: [
                        build(:ingredient,
                              alternatives: [
                                  build(:alternative, raw: build(:raw, name: SecureRandom.hex))
                              ]
                        ),
                        build(:ingredient,
                              alternatives: [
                                  build(:alternative, raw: build(:raw, name: SecureRandom.hex))
                              ]
                        )
                    ]
              ),
              build(:part, position: 2,
                    ingredients: [
                        build(:ingredient,
                              alternatives: [
                                  build(:alternative, raw: build(:raw, name: SecureRandom.hex)),
                                  build(:alternative, raw: build(:raw, name: SecureRandom.hex))
                              ]
                        )
                    ]
              )
          ])
      ])
    end

    let!(:user2) do
      create(:user, foods: [
          create(:food, parts: [
              build(:part, position: 1,
                    ingredients: [
                        build(:ingredient,
                              alternatives: [
                                  build(:alternative, raw: build(:raw, name: SecureRandom.hex))
                              ]
                        ),
                        build(:ingredient,
                              alternatives: [
                                  build(:alternative, raw: build(:raw, name: SecureRandom.hex))
                              ]
                        )
                    ]
              )
          ])
      ])
    end
  end
end
