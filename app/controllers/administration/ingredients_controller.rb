class Administration::IngredientsController < Administration::BaseController

  def create
    part = Part.find_by(id: params[:part_id])
    raw = Raw.find_by(id: params[:raw_id])

    if Alternative.create(raw: raw, ingredient: Ingredient.new(part: part, optional: params[:optional] == "1"))
      flash[:success] = "Ingrediencia bola pridaná úspešne."
    else
      flash[:danger] = "Ingrediencia nebola pridaná."
    end

    redirect_to edit_administration_part_path(part)
  end


  def destroy
    ingredient = Ingredient.find(params[:id])
    part = ingredient.part
    ingredient.destroy

    flash[:success] = "Ingrediencia bola odstránená úspešne."
    redirect_to edit_administration_part_path(part)
  end

end
