require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
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
      it 'saves the new question\'s answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'saves the new user\'s answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: question, format: :js } }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template 'create'
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

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      let(:answer) { create( :answer, question: question, user: @user) }

      it 'assings the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new_body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new_body'
      end

      it 'render update template ' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'update by other user' do
      let(:new_user) { create( :user ) }
      let(:answer) { create( :answer, question: question, user: new_user ) }

      it 'redirects to related question page' do
        process :update, method: :patch, params: { id: answer.id, answer: { body: 'new_body' } }, format: :js
        expect(answer.body).to eq answer.body
      end
    end
  end

end
