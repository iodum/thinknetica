require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    context 'if user is author' do
      let(:question) { create(:question_with_attachment, user: @user) }
      before { question }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question.attachments.first, format: true } }.to change(question.attachments, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, params: { id: question.attachments.first, format: true }
        expect(response).to render_template :destroy
      end
    end

    context 'if user is not author' do
      let(:question_other) { create(:question_with_attachment) }
      before { question_other }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question_other.attachments.first, format: true } }.to_not change(Attachment, :count)
      end
    end
  end
end
