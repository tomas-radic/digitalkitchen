class Users::FoodsController < Users::BaseController

  include FoodsHelper

  before_action :load_record, only: [:show]

  def index
    @records = Pundit.policy_scope!(current_user, Food)
                   .includes(:category, :raws)

    apply_filter! if params[:filter]
    @records = @records.sample(1000)
    set_page_texts
  end

  def show
    @user_raw_ids = current_user.raws.ids
    @record_raw_ids = @record.raws.ids
  end


  private

  def set_page_texts
    if list_available?
      @heading = "Čo všetko si môžeš teraz pripraviť?"
      if @records.any?
        @description = <<DESCRIPTION
Jedlá zobrazené na tejto stránke si môžeš pripraviť hneď teraz, pretože máš na ne doma 
všetky potrebné potraviny. Veľa šťastia :-)
DESCRIPTION
      end
    elsif list_mine?
      @heading = "Tvoje jedlá"
      @description = <<DESCRIPTION
Na tejto stránke sú jedlá, ktoré si sem pridal ty sám. Čím viac jedál tu bude, tým menej
hladní budeme! :-P
DESCRIPTION
    else
      @heading = "Všetky jedlá"
      @description = <<DESCRIPTION
Na tejto stránke sú rôzne jedlá, ktoré si môžeš doma skúsiť pripraviť. Ku každému jedlu
tu nájdeš zoznam potravín, ktoré k jeho príprave potrebuješ. Ak sa prihlásiš, môžeš si 
zaškrtnúť potraviny, ktoré doma už máš a vieme ti tak zobraziť zoznam jedál, ktoré si z nich 
môžeš pripraviť hneď teraz. Ak sa ti nejaké jedlo zapáčilo, no nemáš k nemu doma potraviny,
stačí kliknúť NAKÚPIŤ POTRAVINY a pridáme ti ich na nákupný zoznam.
DESCRIPTION
    end
  end

  def load_record
    @record = Food.find(params[:id])
  end

  def apply_filter!
    if list_available?
      @records = AvailableFoods.call(
          user: current_user,
          foods: @records)
    elsif list_mine?
      @records = @records.where(owner: current_user)
    end
  end

end
