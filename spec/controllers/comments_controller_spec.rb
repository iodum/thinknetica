require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }


  describe 'POST #create for question' do
    sign_in_user
    let(:params) { {question_id: question} }
    let(:commentable) { question }

    it_behaves_like 'Controller Comments'
  end

  describe 'POST #create for answer' do
    sign_in_user
    let(:params) { {answer_id: answer} }
    let(:commentable) { answer }

    it_behaves_like 'Controller Comments'
  end
end
