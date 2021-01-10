class Administration::RawsController < Administration::BaseController

  def index
    @raws = Raw.left_joins(:raw_category).includes(:raw_category)
                .order("categories.name asc")
                .order("raws.name asc")
  end

end
