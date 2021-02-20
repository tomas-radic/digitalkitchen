class Administration::FoodsController < Administration::BaseController

  def index
    @foods = Food.sorted
  end


  def new
    @food = Food.new
    @heading = "Nové jedlo"
  end


  def create
    @food = Food.new(whitelisted_params)

    if @food.save
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_food_path(@food)
    else
      @heading = "Nové jedlo"
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :new
    end
  end


  def edit
    @food = Food.find(params[:id])
    @heading = params[:heading] || @food.name
  end


  def update
    @food = Food.find(params[:id])

    if @food.update(whitelisted_params)
      flash[:success] = "Zmeny boli uložené."
      redirect_to edit_administration_food_path(@food)
    else
      @heading = params[:heading]
      flash.now[:danger] = "Zmeny sa nepodarilo uložiť. Možno chýbajú *požadované informácie."
      render :edit
    end
  end


  def destroy
    Food.find(params[:id]).destroy
    flash[:success] = "Jedlo bolo odstránené úspešne."

    redirect_to administration_foods_path
  end


  def import
    food = nil
    error_message = nil

    begin
      food_json = JSON.parse File.read(params[:file])

      ActiveRecord::Base.transaction do
        food = Food.create!(
            name: food_json["name"],
            description: food_json["description"],
            food_category: FoodCategory.where(name: food_json["category"]).first_or_create!,
            owner: User.find_by!(email: food_json["owner"]),
            owner_private: food_json["owner_private"] || false
        )

        json_parts = food_json["parts"]
        json_parts.each do |json_part|
          part = food.parts.create!(
              name: json_part["name"],
              description: json_part["description"]
          )

          json_ingredients = json_part["ingredients"]
          json_ingredients.sort_by { |i| i["position"] }.each do |json_ingredient|
            ingredient = part.ingredients.create!(optional: json_ingredient["optional"])

            json_alternatives = json_ingredient["alternatives"]
            json_alternatives.each do |json_alternative|
              ingredient.alternatives.create!(raw: Raw.regular.find_by!(name: json_alternative["name"]))
            end
          end if json_ingredients
        end
      end
    rescue ActiveRecord::RecordInvalid,
        ActiveRecord::RecordNotFound,
        JSON::ParserError => e

      error_message = e.message
    end

    if food.persisted?
      flash[:success] = "Import úspešný."
    elsif food.errors.any?
      flash[:danger] = food.errors.to_s
    else
      flash[:danger] = error_message
    end

    redirect_to administration_foods_path
  end


  private

  def whitelisted_params
    params.require(:food).permit(:name, :description, :owner_id, :category_id, :owner_private)
  end

end
