class Administration::PartsController < Administration::BaseController

  def edit
    @part = Part.find(params[:id])
    @heading = params[:heading] || @part.name
  end


  def update
    @part = Part.find(params[:id])

    if @part.update(whitelisted_params)
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_food_path(@part.food)
    else
      @heading = params[:heading]
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :edit
    end
  end


  private

  def whitelisted_params
    params.require(:part).permit(:name, :description)
  end

end
