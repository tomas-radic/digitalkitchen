# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

# puts "\nCreating categories..."
# names = ["Koreniny", "Dochucovadlá", "Zelenina"]
# names.uniq.each do |name|
#   Category.create!(name: name)
# end


puts "\nCreating raws..."
raws = ["kuracie prsia", "morčacie prsia", "arašidy", "vajcia", "škrobová múčka", "kurací vývar",
        "sojová omáčka", "dezertné víno", "chilli papričky", "olej", "soľ", "cukor", "sezam", "ryža"]
raws.uniq.each do |name|
  Raw.create!(name: name)
end


puts "\nCreating foods..."
Food.create!(
    name: "Kung Pao",
    parts: [
        Part.new(
            name: "Príprava mäsa",
            sequence: 1,
            ingredients: [
                Ingredient.new(raws: [Raw.find_by!(name: "kuracie prsia"), Raw.find_by!(name: "morčacie prsia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "soľ")]),
                Ingredient.new(raws: [Raw.find_by!(name: "vajcia")]),
                Ingredient.new(raws: [Raw.find_by!(name: "škrobová múčka")])
            ],
            steps: [
                Step.new(
                    position: 1,
                    description: "Mäso nakrájať na malé rezance, osoliť a obaliť vo vajíčkach zmiešaných so škrobovou múčkou."
                )
            ]
        ),
        Part.new(
            name: "Príprava omáčky",
            sequence: 2,
            ingredients: [
                Ingredient.new(raws: [Raw.find_by!(name: "kurací vývar")]),
                Ingredient.new(raws: [Raw.find_by!(name: "sojová omáčka")]),
                Ingredient.new(raws: [Raw.find_by!(name: "cukor")]),
                Ingredient.new(raws: [Raw.find_by!(name: "soľ")]),
                Ingredient.new(raws: [Raw.find_by!(name: "dezertné víno")]),
                Ingredient.new(raws: [Raw.find_by!(name: "škrobová múčka")])
            ],
            steps: [
                Step.new(
                    position: 1,
                    description: "V miske zmiešať kurací vývar, sojovú omáčku, trochu cukru, soli, víno a trochu škrobu."
                )
            ]
        ),
        Part.new(
            name: "Dokončenie",
            sequence: 3,
            ingredients: [
                Ingredient.new(raws: [Raw.find_by!(name: "chilli papričky")]),
                Ingredient.new(raws: [Raw.find_by!(name: "arašidy")])
            ],
            steps: [
                Step.new(
                    position: 1,
                    description: "Na panvici opražiť obalené mäso, prihodiť chilli papričky a opražené aražidy. Zaliať pripravenou omáčkou a povariť. Podávať s ryžou, posypané sezamom."
                )
            ]
        )
    ]
)

puts "\nDone."
