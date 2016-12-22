require 'rails_helper'

describe 'Answer API' do
  let!(:question) { create(:question) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_pair(:answer, question: question) }
      let!(:other_answer) { create(:answer) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers of questions' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end


  describe 'GET /show' do
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let(:path) { 'answer' }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachmentable'

    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /answers' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      context 'valid data' do
        let(:answer_attr) { { body: 'don\'t hurt me' } }

        before { post "/api/v1/questions/#{question.id}/answers", params: {answer: answer_attr, format: :json, access_token: access_token.token} }

        it 'returns 200 status' do
          expect(response).to be_success
        end

        it 'returns answer' do
          expect(response.body).to have_json_size(1)
        end

        it 'answer object contains body' do
          expect(response.body).to be_json_eql(answer_attr[:body].to_json).at_path('answer/body')
        end
      end

      context 'invalid data' do
        let(:answer_attr) { { body: nil} }

        before { post "/api/v1/questions/#{question.id}/answers", params: {answer: answer_attr, format: :json, access_token: access_token.token} }

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end

        it 'returns question' do
          expect(response.body).to have_json_size(1).at_path('errors')
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

end
