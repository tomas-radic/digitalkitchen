class FoodPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.where("owner_private is false or owner_id = ?", user&.id)
    end
  end

end
