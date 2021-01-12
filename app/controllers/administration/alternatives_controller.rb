class Administration::AlternativesController < Administration::BaseController

  def create
    ingredient = Ingredient.find(params[:ingredient_id])
    raw = Raw.find_by(id: params[:raw_id])

    if raw
      ingredient.raws << raw
      flash[:success] = "Alternatíva bola pridaná úspešne."
    else
      flash[:danger] = "Alternatíva nebola pridaná."
    end

    redirect_to edit_administration_part_path(ingredient.part)
  end

end
