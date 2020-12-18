class OwnershipsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_ownership, only: [:update, :destroy]

  def index
    @ownerships = current_user.ownerships.need_buy.joins(:raw).order("raws.name")
  end

  def destroy
    if @ownership.raw.is_onetime?
      ActiveRecord::Base.transaction do
        raw = @ownership.raw
        @ownership.destroy!
        raw.destroy!
      end
    else
      @ownership.destroy
    end

    @ownerships = current_user.ownerships.need_buy

    respond_to do |format|
      format.js
    end
  end

  def switch_ownership
    ownership = current_user.ownerships.find(params[:id])

    if ownership.raw.is_onetime?
      ActiveRecord::Base.transaction do
        raw = ownership.raw
        ownership.destroy!
        raw.destroy!
      end
    else
      ownership.update!(need_buy: !ownership.need_buy)
    end

    set_user_ownerships

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

  def create_user_raw
    CreateUserRaw.call(
        params[:raw][:name],
        category_id: params[:raw][:category_id],
        user: current_user)

    set_user_ownerships

    respond_to do |format|
      format.js
    end
  end

  private

  def load_ownership
    @ownership = current_user.ownerships.find(params[:id])
  end

  def set_user_ownerships
    @ownerships = current_user.ownerships.need_buy.joins(:raw).order("raws.name")
  end
end
