class CreateUserRaw < BaseService

  def initialize(name, category_id: nil, user:)
    @name = name
    @category_id = category_id
    @user = user
  end


  def call
    ActiveRecord::Base.transaction do
      raw = Raw.regular.find_by(name: @name)
      raw ||= @user.raws.onetime.where(name: @name,
                                       category_id: @category_id.presence).first_or_create

      if raw.persisted?
        ownership = raw.ownerships.where(user: @user).first_or_create
        ownership.update(need_buy: true) unless ownership.need_buy?
      end

      raw
    end
  end
end
