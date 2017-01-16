class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user
  end

  def destroy?

    user.admin? || user.author_of?(record) || user.is_subscribed(record) if user
  end
end
