class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user
  end

  def update?
    user.admin? || user == record.user if user
  end

  def destroy?
    user.admin? || user == record.user if user
  end

  def accept?
    user == record.question.user if user
  end

  def vote_up?
    user != record.user if user
  end

  def vote_down?
    user != record.user if user
  end
end
