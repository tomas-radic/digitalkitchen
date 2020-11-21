class ArrangedRaws < BaseCalculation

  def initialize(food)
    @food = food
  end

  def call
    single_raws.merge(raws_with_alternatives) do |key, old_value, new_value|
      new_value.each do |a|
        old_value << a
      end
    end
  end

  private

  def single_raws
    query = <<QUERY
select distinct raws.id as raw_id,
                raws.name as raw_name,
                c.name as category_name,
                i2.optional as optional
from raws
         join alternatives a2 on raws.id = a2.raw_id
         join ingredients i2 on a2.ingredient_id = i2.id
         left join categories c on raws.category_id = c.id
where i2.id in (
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
    where raw_counts.raw_count = 1)
order by optional;
QUERY

    @single_raws ||= ActiveRecord::Base.connection.execute(query).group_by do |raw|
      raw["category_name"]
    end
  end


  def raws_with_alternatives
    return @raws_with_alternatives if @raws_with_alternatives

    query = <<QUERY
select * from ingredients
where ingredients.id in (
    select id from (
                       select count(a.ingredient_id) as raw_count,
                              i.id as id from alternatives a
                                                  join ingredients i on a.ingredient_id = i.id
                                                  join parts p on i.part_id = p.id
                                                  join raws r on a.raw_id = r.id
                       where p.food_id = '#{@food.id}'
                       group by a.ingredient_id, i.id
                       order by raw_count
                   ) as raw_counts
    where raw_counts.raw_count > 1)
order by ingredients.optional;
QUERY

    @raws_with_alternatives = {}

    ingredients = Ingredient.where(
        id: ActiveRecord::Base.connection.execute(query).map { |i| i["id"] })
                      .includes(alternatives: { raw: :raw_category })
                      .order("ingredients.optional")

    grouped_by_category = ingredients.group_by { |i| i.raws.first.raw_category&.name }

    @raws_with_alternatives = grouped_by_category.tap do |gbc|
      gbc.keys.each do |category|
        gbc[category] = gbc[category].map do |ingredient|
          ingredient.raws.map do |raw|
            {
                "raw_id" => raw.id,
                "raw_name" => raw.name,
                "category_name" => raw.raw_category&.name,
                "optional" => ingredient.optional
            }
          end
        end
      end
    end
  end
end
