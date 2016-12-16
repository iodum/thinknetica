class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  include ResourcePolicy

  def accept?
    user.author_of?(record.question) if user
  end

end
