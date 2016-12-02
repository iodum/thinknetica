require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }


  describe 'POST #create for question' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question\'s comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         question_id: question, format: :js } }.to change(question.comments, :count).by(1)
      end

      it 'saves the new user\'s comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         question_id: question, format: :js } }.to change(@user.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :js } }.to_not change(Comment, :count)
      end

      it 're-renders new view' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :js }
        expect(response).to render_template 'layouts/common/flash'
      end
    end
  end

  describe 'POST #create for answer' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer\'s comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         answer_id: answer, format: :js } }.to change(answer.comments, :count).by(1)
      end

      it 'saves the new answer\'s comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         answer_id: answer, format: :js } }.to change(@user.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), answer_id: answer, format: :js } }.to_not change(Comment, :count)
      end

      it 're-renders new view' do
        post :create, params: { comment: attributes_for(:invalid_comment), answer_id: answer, format: :js }
        expect(response).to render_template 'layouts/common/flash'
      end
    end
  end
end
