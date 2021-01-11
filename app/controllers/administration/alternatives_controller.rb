class Administration::AlternativesController < Administration::BaseController

  def create
    ingredient = Ingredient.find(params[:ingredient_id])
    raw = Raw.find(params[:raw_id])
    ingredient.raws << raw

    flash[:success] = "Alternatíva bola pridaná úspešne."
    redirect_to edit_administration_part_path(ingredient.part)
  end

end
