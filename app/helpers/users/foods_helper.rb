module Users::FoodsHelper

  def food_about_text(food)
    food.description.presence || food.ingredients.map(&:name).join(' - ')
  end


  def food_index_heading
    @heading ||= if listing_available_foods?
                   "Čo všetko si môžeš teraz pripraviť?"
                 elsif listing_owner_foods?
                   "Tvoje jedlá"
                 else
                   "Všetky jedlá"
                 end
  end


  def food_index_description
    @description ||= if listing_available_foods?
                       if @records.any?
                         <<DESCRIPTION
Jedlá zobrazené na tejto stránke si môžeš pripraviť hneď teraz, pretože máš na ne doma 
všetky potrebné potraviny. Veľa šťastia :-)
DESCRIPTION
                       end
                     elsif listing_owner_foods?
                       <<DESCRIPTION
Na tejto stránke sú jedlá, ktoré si sem pridal ty sám. Čím viac jedál tu bude, tým menej
hladní budeme! :-P
DESCRIPTION
                     else
                       <<DESCRIPTION
Na tejto stránke sú rôzne jedlá, ktoré si môžeš doma skúsiť pripraviť. Ku každému jedlu
tu nájdeš zoznam potravín, ktoré k jeho príprave potrebuješ a popis prípravy. Ak sa prihlásiš, môžeš si 
zaškrtnúť potraviny, ktoré doma už máš a vieme ti tak zobraziť zoznam jedál, ktoré si z nich 
môžeš pripraviť hneď teraz. Ak sa ti nejaké jedlo zapáčilo, no nemáš k nemu doma potraviny,
stačí kliknúť NAKÚPIŤ POTRAVINY a pridáme ti ich na nákupný zoznam. Zásoby svojich potravín
potom nájdeš v menu \"Chladnička\".
DESCRIPTION
                     end
  end


  def listing_available_foods?
    params[:filter] == "available"
  end


  def listing_owner_foods?
    params[:filter] == "mine"
  end
end
