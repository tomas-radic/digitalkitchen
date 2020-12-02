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
            "koriander",
            "petržlenová vňať"
        ],
        "Koreniny" => [
            "čierne korenie",
            "rasca",
            "zelené korenie"
        ],
        "Mäsové výrobky" => [
            "anglická slanina",
            "kuracie prsia",
            "morčacie prsia",
            "oravská slanina",
            "pancetta"
        ],
        "Mliečne výrobky" => [
            "parmezán",
            "pecorino"
        ],
        "Omáčky" => [
            "rybacia omáčka",
            "sojová omáčka"
        ],
        "Zelenina" => [
            "baklažán",
            "bambusové výhonky",
            "cesnak",
            "cibuľa",
            "chilli papričky",
            "cuketa",
            "hrubá červená paprika",
            "hrubá sladká paprika",
            "šalotka",
            "šampióny",
            "zázvor"
        ],
        nil => [
            "arašidy",
            "citrónová šťava",
            "citrónová tráva",
            "cukor",
            "červená kari pasta",
            "dezertné víno",
            "kokosové mlieko",
            "kurací vývar",
            "olej",
            "ryža",
            "sezam",
            "soľ",
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
          raw = Raw.where(name: raw_name).first_or_create!
          category.raws << raw if category
        end
      end
    end

    puts "Done.\n"
  end
end
