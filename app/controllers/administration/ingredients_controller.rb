class Administration::IngredientsController < Administration::BaseController

  def create
    part = Part.find(params[:part_id])
    raw = Raw.find(params[:raw_id])
    Alternative.create(raw: raw, ingredient: Ingredient.new(part: part))

    flash[:success] = "Ingrediencia bola pridaná úspešne."
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
