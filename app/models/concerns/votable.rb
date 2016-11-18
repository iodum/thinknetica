module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    add_vote(user, 1)
  end

  def vote_down(user)
    add_vote(user, -1)
  end

  def rating
    votes.sum(:value)
  end

  def has_votes?(user, value = nil)
    if value.nil?
      votes.find_by(user: user).present?
    else
      votes.find_by(user: user, value: value).present?
    end
  end

  private
  def cancel(user)
    votes.where(user: user).delete_all
  end

  def add_vote(user, value)
    val = 0
    if user.id == self.user_id
      error = 'You can\'t vote, you is owner'
      {success: false, error: error, rating: rating, value: val}
    elsif has_votes?(user)
      cancel(user)
    else
      votes.create(user: user, value: value)
      val = value
    end

    {success: true, rating: rating, value: val}

  end

end