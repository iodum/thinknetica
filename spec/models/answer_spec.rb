require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:accepted).scoped_to(:question_id) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }

  describe '#accept' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    it 'accept new answer' do
      answer.accept
      expect(answer.reload).to be_accepted
    end

    it 'change accepting answer' do
      answer2 =  create(:answer, question: question, accepted: true )
      answer.accept
      expect(answer.reload).to be_accepted
    end
  end
end
