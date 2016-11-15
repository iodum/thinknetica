class Answer < ApplicationRecord
  include Votable

  default_scope { order(accepted: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true, length: { minimum: 5 }
  validates :accepted, uniqueness: { scope: :question_id }, if: :accepted?

  def accept
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update!(accepted: true)
    end
  end
end
