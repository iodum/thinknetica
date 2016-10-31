require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, params: { question_id: question } }

    it 'assings a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: question } }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'if user is author' do
      let(:user_answer) { create(:answer, user: @user) }
      before { user_answer }

      it 'delete answer' do
        expect { delete :destroy, params: { id: user_answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, params: { id: user_answer }
        expect(response).to redirect_to user_answer.question
      end
    end

    context 'if user is not author' do
      let(:answer) { create(:answer, user: user) }
      before { answer }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end

end
