require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:accepted).scoped_to(:question_id) }

  describe '#accept' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    it 'accept new answer' do
      answer1.update!(accepted: true )
      answer2.accept
      expect(answer1.reload).to_not be_accepted
      expect(answer2.reload).to be_accepted
    end
  end
end
