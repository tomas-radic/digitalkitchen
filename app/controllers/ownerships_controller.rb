class OwnershipsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_ownership, only: [:update, :destroy]

  def index
    @ownerships = current_user.ownerships.need_buy.joins(:raw).order("raws.name")
  end

  def create
    current_user.ownerships.where(whitelisted_params).first_or_create!

    @raws = Raw.all
    @ownerships = current_user.ownerships.to_a

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @ownership.destroy
    @ownerships = current_user.ownerships.need_buy

    respond_to do |format|
      format.js
    end
  end

  def switch_ownership
    ownership = current_user.ownerships.find(params[:id])
    ownership.update!(need_buy: !ownership.need_buy)
    @ownerships = current_user.ownerships.need_buy.joins(:raw).order("raws.name")

    respond_to do |format|
      format.js
    end
  end

  def add_all
    @food = policy_scope(Food).find(params[:food_id])

    @food.raws.each do |raw|
      current_user.ownerships.where(raw: raw).first_or_create!(need_buy: true)
    end

    @ownerships = current_user.ownerships.to_a

    flash[:success] = "Potraviny boli pridané na nákupný zoznam."
    redirect_to food_path(@food)
  end

  def remove_all
    current_user.ownerships.need_buy.destroy_all

    flash[:success] = "Nákupný zoznam je prázdny"
    redirect_to ownerships_path
  end

  private

  def whitelisted_params
    params.require(:ownership).permit(:raw_id, :need_buy)
  end

  def load_ownership
    @ownership = current_user.ownerships.find(params[:id])
  end
end
