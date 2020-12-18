class RawPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.left_joins(:ownerships)
          .where("raws.is_onetime is false or ownerships.user_id = ?", user.id)
    end
  end

end
