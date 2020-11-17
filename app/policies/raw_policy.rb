class RawPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.joins(
          alternatives: { ingredient: { part: :food } })
          .where("foods.owner_private is false or foods.owner_id = ?", user.id)
    end
  end

end
