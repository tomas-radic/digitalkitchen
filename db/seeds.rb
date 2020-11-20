# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

ActiveRecord::Base.transaction do
  # ----------------------- Users -----------------------
  puts "\nAdding users..."
  User.where(email: "tomas.radic@gmail.com").first_or_create!(nickname: "dino")


  # ----------------------- Raws -----------------------
  puts "\nAdding raws..."
  raws = {
      "Zelenina" => ["chilli papričky", "hrubá sladká paprika", "cibuľa", "šalotka", "cesnak"],
      "Koreniny" => ["čierne korenie", "zelené korenie", "rasca"],
      "Bylinky" => ["petržlenová vňať"],
      "Omáčky" => ["sojová omáčka"],
      "Mäsové výrobky" => ["kuracie prsia", "morčacie prsia"],
      nil => ["arašidy", "vajcia", "škrobová múčka", "kurací vývar", "dezertné víno", "olej",
              "soľ", "cukor", "sezam", "ryža"]
  }

  raws.each do |category_name, raw_names|
    category = if category_name
                 RawCategory.where(name: category_name).first_or_create!
               end

    raw_names.each do |raw_name|
      raw = Raw.where(name: raw_name).first_or_create!
      category.raws << raw if category
    end
  end


  # ----------------------- Foods -----------------------
  puts "\nAdding foods..."
  name = "Kung Pao"
  unless Food.find_by(name: name)
    Food.create!(
        name: name,
        food_category: FoodCategory.where(name: "Ázijská kuchyňa").first_or_create!,
        owner: User.all.sample
    ).tap do |food|

      food.parts.create!(
          name: "Príprava mäsa",
          description: "Mäso nakrájaj na malé rezance, osoľ a obal vo vajíčkach zmiešaných so škrobovou múčkou."
      ).tap do |part|
        part.ingredients.create!.tap do |ingredient|

          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "kuracie prsia")
          )
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "morčacie prsia")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "soľ")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "vajcia")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "škrobová múčka")
          )
        end
      end

      food.parts.create!(
          name: "Omáčka",
          description: "V miske zmiešaj kurací vývar, sojovú omáčku, trochu cukru, soli, víno a trochu škrobu."
      ).tap do |part|
        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "kurací vývar")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "sojová omáčka")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "cukor")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "soľ")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "dezertné víno")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw:Raw.find_by!(name: "škrobová múčka")
          )
        end
      end

      food.parts.create!(
          name: "Dokončenie",
          description: "Obalené mäso opraž na panvici, prihoď chilli papričky a opražené aražidy. Zalej to pripravenou omáčkou a chvíľu povar. Podávaj s ryžou, posypané sezamom."
      ).tap do |part|
        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "chilli papričky")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "arašidy")
          )
        end

        part.ingredients.create!(optional: true).tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "sezam")
          )
        end
      end
    end
  end

  name = "Čína"
  unless Food.find_by(name: name)
    Food.create!(
        name: name,
        food_category: FoodCategory.where(name: "Ázijská kuchyňa").first_or_create!,
        owner: User.all.sample
    ).tap do |food|

      food.parts.create!(
          name: "Príprava surovín",
          description: "Tu si pripravíš zeleninu a zálievku, ktorú využiješ neskôr. Papriku nakrájaj na podlhovasté slíže, cibuľu/šalotku a chilli papričky na pol/kolieska a ulož do misky. V druhej miske si priprav vo vode rozmiešanú škrobovú múčku."
      ).tap do |part|
        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "hrubá sladká paprika")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "chilli papričky")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "cibuľa")
          )

          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "šalotka")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "škrobová múčka")
          )
        end
      end

      food.parts.create!(
          name: "Príprava mäsa",
          description: "Tu orestuješ a dochutíš mäso a zmiešaš s ostatným. Cesnak prelisuj a zmiešaj s olejom. Na woku, alebo panvici na ňom zľahka orestuj arašidy. Potom zvýš teplotu a prudšie v tom orestuj mäso, ktoré ku koncu podľa chuti osoľ a okoreň.\nPrilej škrobovú múčku zmiešanú s vodou nachystanú v miske a po chvíli aj nakrájanú zeleninu z druhej misky a chvíľu to spolu povar. Na konci do toho vmiešaj petržlenovú vňať a podávaj s ryžou."
      ).tap do |part|
        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "kuracie prsia")
          )

          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "morčacie prsia")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "cesnak")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "arašidy")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "olej")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "soľ")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "čierne korenie")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "petržlenová vňať")
          )
        end

        part.ingredients.create!.tap do |ingredient|
          Alternative.create!(
              ingredient: ingredient,
              raw: Raw.find_by!(name: "ryža")
          )
        end
      end
    end
  end


  puts "\nDone."
end
