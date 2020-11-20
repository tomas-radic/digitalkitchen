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
                       if @foods.any?
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


  def food_raws(food)
    <<QUERY
select distinct * from raws
join alternatives a2 on raws.id = a2.raw_id
join ingredients i2 on a2.ingredient_id = i2.id
where i2.id in (
    select id from (
                       select count(a.ingredient_id) as raw_count, i.id as id from alternatives a
                                                                                       join ingredients i on a.ingredient_id = i.id
                                                                                       join parts p on i.part_id = p.id
                                                                                       join raws r on a.raw_id = r.id
                       where p.food_id = '03cb6adc-244b-461c-a205-8b8e489c2f9e'
                       group by a.ingredient_id, i.id
                       order by raw_count
                   ) as raw_counts
    where raw_counts.raw_count = 1
);
QUERY

  end
end
