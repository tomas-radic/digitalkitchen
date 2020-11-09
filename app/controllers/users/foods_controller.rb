class Users::FoodsController < Users::BaseController

  before_action :load_record, only: [:show]

  def index
  end

  def show
    @user_raw_ids = current_user.raws.ids
    @record_raw_ids = @record.raws.ids
  end


  private

  def load_record
    @record = Food.find(params[:id])
  end

end
