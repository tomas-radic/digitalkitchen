# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

puts "\nCreating users..."
User.create(email: "tomas.radic@gmail.com", name: "dino")


puts "\nCreating categories..."
food_categories = ["Ázijská kuchyňa"]
raw_categories = ["Mäso", "Koreniny", "Dochucovadlá", "Zelenina", "Ovocie", "Bylinky"]
food_categories.each do |name|
  FoodCategory.create!(name: name)
end
raw_categories.each do |name|
  RawCategory.create!(name: name)
end


puts "\nCreating raws..."
meats = ["kuracie prsia", "morčacie prsia"]
vegetables = ["chilli papričky", "hrubá sladká paprika", "cibuľa", "šalotka", "cesnak"]
peppers = ["čierne korenie", "zelené korenie", "rasca"]
herbs = ["petržlenová vňať"]
general = ["arašidy", "vajcia", "škrobová múčka", "kurací vývar",
           "sojová omáčka", "dezertné víno", "olej", "soľ", "cukor", "sezam", "ryža"]
meat_category = RawCategory.find_by!(name: "Mäso")
meats.uniq.each do |name|
  meat_category.raws.create!(name: name)
end
vegetable_category = RawCategory.find_by!(name: "Zelenina")
vegetables.uniq.each do |name|
  vegetable_category.raws.create!(name: name)
end
pepper_category = RawCategory.find_by!(name: "Koreniny")
peppers.uniq.each do |name|
  pepper_category.raws.create!(name: name)
end
herbs_category = RawCategory.find_by!(name: "Bylinky")
herbs.uniq.each do |name|
  herbs_category.raws.create!(name: name)
end
general.uniq.each do |name|
  Raw.create!(name: name)
end


puts "\nCreating foods..."
Food.create!(
    name: "Kung Pao",
    food_category: FoodCategory.find_by!(name: "Ázijská kuchyňa"),
    owner: User.all.sample,
    parts: [
        Part.new(
            name: "Príprava mäsa",
            position: 1,
            ingredients: [
                Ingredient.new(raw_category: RawCategory.find_by!(name: "Mäso"), raws: [Raw.find_by!(name: "kuracie prsia"), Raw.find_by!(name: "morčacie prsia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "soľ")]),
                Ingredient.new(raws: [Raw.find_by!(name: "vajcia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "škrobová múčka")])
            ],
            description: "Mäso nakrájaj na malé rezance, osoľ a obal vo vajíčkach zmiešaných so škrobovou múčkou."
        ),
        Part.new(
            name: "Príprava omáčky",
            position: 2,
            ingredients: [
                Ingredient.new(raws: [Raw.find_by!(name: "kurací vývar")]),
                Ingredient.new(raws: [Raw.find_by!(name: "sojová omáčka")]),
                Ingredient.new(raws: [Raw.find_by!(name: "cukor")]),
                Ingredient.new(raws: [Raw.find_by!(name: "soľ")]),
                Ingredient.new(raws: [Raw.find_by!(name: "dezertné víno")]),
                Ingredient.new(raws: [Raw.find_by!(name: "škrobová múčka")])
            ],
            description: "V miske zmiešaj kurací vývar, sojovú omáčku, trochu cukru, soli, víno a trochu škrobu."
        ),
        Part.new(
            name: "Dokončenie",
            position: 3,
            ingredients: [
                Ingredient.new(raw_category: RawCategory.find_by!(name: "Zelenina"), raws: [Raw.find_by!(name: "chilli papričky")]),
                Ingredient.new(raws: [Raw.find_by!(name: "arašidy")])
            ],
            description: "Obalené mäso opraž na panvici, prihoď chilli papričky a opražené aražidy. Zalej to pripravenou omáčkou a chvíľu povar. Podávaj s ryžou, posypané sezamom."
        )
    ]
)


Food.create!(
    name: "Čína",
    food_category: FoodCategory.find_by!(name: "Ázijská kuchyňa"),
    owner: User.all.sample,
    parts: [
        Part.new(
            name: "Predpríprava",
            position: 1,
            ingredients: [
                Ingredient.new(raw_category: RawCategory.find_by!(name: "Zelenina"), raws: [Raw.find_by!(name: "hrubá sladká paprika")]),
                Ingredient.new(raw_category: RawCategory.find_by!(name: "Zelenina"), raws: [Raw.find_by!(name: "chilli papričky")]),
                Ingredient.new(raw_category: RawCategory.find_by!(name: "Zelenina"), raws: [Raw.find_by!(name: "cibuľa"), Raw.find_by!(name: "šalotka")]),
                Ingredient.new(raws: [Raw.find_by!(name: "škrobová múčka")])
            ],
            description: "Papriku nakrájaj na podlhovasté slíže, cibuľu/šalotku a chilli papričky na pol/kolieska a ulož do misky. V druhej miske si priprav vo vode rozmiešanú škrobovú múčku."
        ),
        Part.new(
            name: "Príprava mäsa",
            position: 2,
            ingredients: [
                Ingredient.new(raw_category: RawCategory.find_by!(name: "Mäso"), raws: [Raw.find_by!(name: "kuracie prsia"), Raw.find_by!(name: "morčacie prsia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "cesnak")]),
                Ingredient.new(raws: [Raw.find_by!(name: "arašidy")]),
                Ingredient.new(raws: [Raw.find_by!(name: "olej")]),
                Ingredient.new(raws: [Raw.find_by!(name: "soľ")]),
                Ingredient.new(raws: [Raw.find_by!(name: "čierne korenie")]),
                Ingredient.new(raws: [Raw.find_by!(name: "petržlenová vňať")]),
                Ingredient.new(raws: [Raw.find_by!(name: "ryža")])
            ],
            description: "Cesnak prelisuj a zmiešaj s olejom. Na woku, alebo panvici na ňom mierne orestuj arašidy. Potom zvýš teplotu a prudšie v tom orestuj mäso, ktoré ku koncu podľa chuti osoľ a okoreň.\nPrilej škrobovú múčku zmiešanú s vodou nachystanú v miske a po chvíli aj nakrájanú zeleninu z druhej misky a chvíľu to spolu povar. Na konci do toho vmiešaj petržlenovú vňať a podávaj s ryžou."
        )
    ]
)

puts "\nDone."
