class Administration::RawsController < Administration::BaseController

  def index
    @raws = Raw.left_joins(:raw_category).includes(:raw_category)
                .order("categories.name asc")
                .order("raws.name asc")
  end


  def new
    @raw = Raw.new(category_id: params[:category_id])
    @heading = "Nová surovina"
  end


  def create
    @raw = Raw.new(whitelisted_params)

    if @raw.save
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_raw_path(@raw)
    else
      @heading = "Nová surovina"
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :new
    end
  end


  def edit
    @raw = Raw.find(params[:id])
    @parts = @raw.parts.distinct.includes(:food)
    @heading = params[:heading] || @raw.name
  end


  def update
    @raw = Raw.find(params[:id])

    if @raw.update(whitelisted_params)
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_raw_path(@raw)
    else
      @parts = @raw.parts.distinct.includes(:food)
      @heading = params[:heading]
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :edit
    end
  end


  def destroy
    Raw.find(params[:id]).destroy
    flash[:success] = "Surovina bola odstránená úspešne."

    redirect_to administration_raws_path
  end


  private

  def whitelisted_params
    params.require(:raw).permit(:name, :category_id)
  end

end
