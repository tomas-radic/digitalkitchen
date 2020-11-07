class FoodsController < ApplicationController

  before_action :load_record, only: [:show]

  def index
  end

  def show
  end


  private

  def load_record
    @record = Food.find(params[:id])
  end

end
