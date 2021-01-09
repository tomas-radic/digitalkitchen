namespace :data do

  # "rake data:users"
  desc "Creates users if not existing"
  task :users => :environment do
    emails = [
        "tomas.radic@gmail.com"
    ]

    puts "\nAdding users..."
    emails.each do |email|
      User.where(email: email).first_or_create!(
          name: email.split('@')[0],
          password: email.gsub('@', '##') # to be changed by user themself
      )
    end

    puts "Done.\n"
  end


  # "rake data:raws"
  desc "Creates raws if not existing"
  task :raws => :environment do
    raws = {
        "Bylinky" => [
            "bazalka",
            "koriander",
            "petržlenová vňať"
        ],
        "Koreniny" => [
            "čierne korenie",
            "rasca celá",
            "zelené korenie"
        ],
        "Mäsové výrobky" => [
            "anglická slanina",
            "bravčová panenka",
            "kuracie prsia",
            "morčacie prsia",
            "oravská slanina",
            "pancetta"
        ],
        "Mliečne výrobky" => [
            "maslo",
            "parmezán",
            "pecorino"
        ],
        "Nápoje" => [
            "pivo",
            "sladké biele víno",
            "suché biele víno",
            "whisky"
        ],
        "Omáčky" => [
            "rybacia omáčka",
            "sojová omáčka",
            "worcesterová omáčka"
        ],
        "Pečivo" => [
            "pečivo"
        ],
        "Zelenina a ovocie" => [
            "baklažán",
            "bambusové výhonky",
            "batáty",
            "biela reďkovka",
            "cesnak",
            "cibuľa",
            "citrónová šťava",
            "citrónová tráva",
            "cherry paradajky",
            "chilli papričky",
            "cuketa",
            "červená reďkovka",
            "hrubá sladká paprika",
            "listový šalát",
            "pomaranče",
            "rukola",
            "šalotka",
            "šampióny",
            "zázvor",
            "zeleninová paprika",
            "zemiaky"
        ],
        nil => [
            "arašidy",
            "cukor",
            "červená kari pasta",
            "hladká múka",
            "kakao",
            "kokosové mlieko",
            "kukuričky v konzerve",
            "kurací vývar",
            "med",
            "olej",
            "olivový olej",
            "paradajkový pretlak",
            "práškový cukor",
            "prášok do pečiva",
            "ryža",
            "sezam",
            "soľ",
            "sušený cesnak",
            "škrobová múčka",
            "špagety",
            "trstinový cukor",
            "vajcia"
        ]
    }

    puts "\nAdding raws..."
    ActiveRecord::Base.transaction do
      raws.each do |category_name, raw_names|
        category = if category_name
                     RawCategory.where(name: category_name).first_or_create!
                   end

        raw_names.each do |raw_name|
          raw = Raw.regular
              .where(name: raw_name)
              .first_or_create!

          raw.raw_category = category
        end
      end
    end

    puts "Done.\n"
  end
end
