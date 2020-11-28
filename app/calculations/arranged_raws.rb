class ArrangedRaws < BaseCalculation

  def initialize(food)
    @food = food
  end

  def call
    result = {}

    single_ingredients.each do |si_category, si_category_ingredients|
      result[si_category] ||= []

      si_category_ingredients.each do |ingredient|
        raw = ingredient.raws.first
        included_raw = result[si_category].find { |r| r[:raw_id] == raw.id }

        if included_raw
          included_raw[:optional] = false unless ingredient.optional?
        else
          result[si_category] << {
              raw_id: raw.id,
              raw_name: raw.name,
              category_name: si_category,
              optional: ingredient.optional?
          }
        end
      end


      if alternative_ingredients[si_category]

        alternative_ingredients[si_category].each do |ingredient|
          result[si_category] << ingredient.raws.map do |raw|
            {
                raw_id: raw.id,
                raw_name: raw.name,
                category_name: si_category,
                optional: ingredient.optional?
            }
          end
        end

        alternative_ingredients.delete(si_category)
      end
    end

    if alternative_ingredients.any?
      alternative_ingredients.each do |ai_category, ai_ingredients|
        result[ai_category] ||= []

        ai_ingredients.each do |ingredient|
          result[ai_category] << ingredient.raws.map do |raw|
            {
                raw_id: raw.id,
                raw_name: raw.name,
                category_name: ai_category,
                optional: ingredient.optional?
            }
          end
        end
      end
    end

    result
  end


  private

  def single_ingredients
    return @single_ingredients if @single_ingredients

    ingredient_ids = ActiveRecord::Base.connection.execute(ingredients_query.gsub("<operator>", "="))
    @single_ingredients = @food.ingredients
                              .where(id: ingredient_ids.map { |id| id["id"] })
                              .order(:optional)
                              .joins(:raws)
                              .includes(:raws).group_by do |ingredient|
      ingredient.raws.first.raw_category&.name
    end
  end


  def alternative_ingredients
    return @alternative_ingredients if @alternative_ingredients

    ingredient_ids = ActiveRecord::Base.connection.execute(ingredients_query.gsub("<operator>", ">"))
    @alternative_ingredients = @food.ingredients
                      .where(id: ingredient_ids.map { |id| id["id"] })
                      .order(:optional)
                      .joins(:raws)
                      .includes(:raws).group_by do |ingredient|
      ingredient.alternatives.find_by(position: 1).raw.raw_category&.name
    end
  end

  def ingredients_query
    <<QUERY
select id from (
                   select
                       count(a.ingredient_id) as raw_count,
                       i.id as id from alternatives a
                                           join ingredients i on a.ingredient_id = i.id
                                           join parts p on i.part_id = p.id
                                           join raws r on a.raw_id = r.id
                   where p.food_id = '#{@food.id}'
                   group by a.ingredient_id, i.id
                   order by raw_count
               ) as raw_counts
where raw_counts.raw_count <operator> 1;
QUERY
  end
end
