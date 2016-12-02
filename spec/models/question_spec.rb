require 'rails_helper'
require_relative 'concerns/votable'
require_relative 'concerns/commentable'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should accept_nested_attributes_for :attachments }
end
