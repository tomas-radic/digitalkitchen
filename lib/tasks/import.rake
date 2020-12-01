namespace :import do

  # "rake import:food\[25\]" - to run with 25 as param
  desc "Imports food from json file"
  task :food, [:food_json_id] => :environment do |t, args|
    file_path = Rails.root.join("lib", "import", "#{args[:food_json_id]}.json")
    result = ImportFood.call(file_path)

    if result.is_a? Food
      puts "Food created!\n#{Rails.application.routes.url_helpers.food_path(result)}"
    else
      puts "Error while creating food\n#{result}"
    end
  end


  # "rake import:all_foods"
  desc "Imports all foods from all lib/import/*.json files"
  task :all_foods => :environment do

    unless Rails.env.development?
      puts "This task works in development environment only."
      return
    end

    json_files = Dir.entries(Rails.root.join("lib", "import")).reject! { |name| !name.match? /\.json$/ }
    json_files.each do |json_file|
      file_path = Rails.root.join("lib", "import", json_file)
      result = ImportFood.call(file_path)

      if result.is_a? Food
        puts "Food created!\n#{Rails.application.routes.url_helpers.food_path(result)}"
      else
        puts "Error while creating food\n#{result}"
      end
    end
  end

end
