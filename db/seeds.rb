# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

puts "\nCreating users..."
User.create(email: "tomas.radic@gmail.com", name: "dino")


puts "\nCreating categories..."
food_categories = ["Ázijská kuchyňa"]
raw_categories = ["Mäso", "Koreniny", "Dochucovadlá", "Zelenina", "Ovocie"]
food_categories.each do |name|
  FoodCategory.create!(name: name)
end
raw_categories.each do |name|
  RawCategory.create!(name: name)
end


puts "\nCreating raws..."
meats = ["kuracie prsia", "morčacie prsia"]
vegetables = ["chilli papričky"]
peppers = ["čierne korenie", "zelené korenie", "rasca"]
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
general.uniq.each do |name|
  Raw.create!(name: name)
end


puts "\nCreating foods..."
Food.create!(
    name: "Kung Pao",
    category: FoodCategory.find_by!(name: "Ázijská kuchyňa"),
    owner: User.all.sample,
    parts: [
        Part.new(
            name: "Príprava mäsa",
            position: 1,
            ingredients: [
                Ingredient.new(raws: [Raw.find_by!(name: "kuracie prsia"), Raw.find_by!(name: "morčacie prsia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "soľ")]),
                Ingredient.new(raws: [Raw.find_by!(name: "vajcia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "škrobová múčka")])
            ],
            description: "Mäso nakrájať na malé rezance, osoliť a obaliť vo vajíčkach zmiešaných so škrobovou múčkou."
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
            description: "V miske zmiešať kurací vývar, sojovú omáčku, trochu cukru, soli, víno a trochu škrobu."
        ),
        Part.new(
            name: "Dokončenie",
            position: 3,
            ingredients: [
                Ingredient.new(raws: [Raw.find_by!(name: "chilli papričky")]),
                Ingredient.new(raws: [Raw.find_by!(name: "arašidy")])
            ],
            description: "Na panvici opražiť obalené mäso, prihodiť chilli papričky a opražené aražidy. Zaliať pripravenou omáčkou a povariť. Podávať s ryžou, posypané sezamom."
        )
    ]
)

puts "\nDone."
