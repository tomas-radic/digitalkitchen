module FoodsHelper

  def food_about_text(food)
    food.description.presence || food.ingredients.map(&:name).join(' - ')
  end


  def link_to_foods(label:, list: nil, css_classes: nil, &block)
    filter = { filter: { list: list } }
    path = if user_signed_in?
             users_foods_path(filter)
           else
             foods_path(filter)
           end

    if block_given?
      link_to path, class: css_classes, &block
    else
      link_to label, path, class: css_classes
    end

  end

end
