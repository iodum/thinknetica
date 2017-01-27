class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true, touch: true
  belongs_to :user

  validates :value, inclusion: [1, -1]
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

end
