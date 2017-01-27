class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question, touch: true

  validates :question_id, uniqueness: { scope: :user_id }
end
