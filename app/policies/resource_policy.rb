module ResourcePolicy

  def create?
    user
  end

  def update?
    user.admin? || user.author_of?(record) if user
  end

  def destroy?
    user.admin? || user.author_of?(record) if user
  end

  def vote_up?
    !user.author_of?(record) if user
  end

  def vote_down?
    !user.author_of?(record) if user
  end

end
