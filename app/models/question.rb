class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true, length: {minimum: 5}

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create_commit :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user_id: self.user_id)
  end
end
