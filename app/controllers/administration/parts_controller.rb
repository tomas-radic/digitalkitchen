class Administration::PartsController < Administration::BaseController

  def new
    @part = Part.new(food: Food.find(params[:food_id]))
    @heading = "Nová fáza"
  end


  def create
    @part = Part.new(whitelisted_params)
    @part.food = Food.find(params[:food_id])

    if @part.save
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_part_path(@part)
    else
      @heading = "Nová fáza"
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :new
    end
  end


  def edit
    @part = Part.find(params[:id])
    @heading = params[:heading] || @part.name
    @raws = Raw.sorted
  end


  def update
    @part = Part.find(params[:id])

    if @part.update(whitelisted_params)
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_part_path(@part)
    else
      @heading = params[:heading]
      @raws = Raw.sorted
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :edit
    end
  end


  def destroy
    part = Part.find(params[:id])
    food = part.food
    part.destroy

    flash[:success] = "Fáza bola odstránená úspešne."
    redirect_to edit_administration_food_path(food)
  end


  private

  def whitelisted_params
    params.require(:part).permit(:name, :description)
  end

end
