class AttachmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    user.admin? || user.author_of?(record.attachable) if user
  end
end
