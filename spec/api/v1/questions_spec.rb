require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_pair(:question) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end


  describe 'GET /show' do

    let!(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let(:path) { 'question' }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachmentable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /questions' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      context 'valid data' do
        let(:question_attr) do
          {
            title: 'New question',
            body: 'What is love?'}
        end

        before { post '/api/v1/questions', params: {question: question_attr, format: :json, access_token: access_token.token} }

        it 'returns 200 status' do
          expect(response).to be_success
        end

        it 'returns question' do
          expect(response.body).to have_json_size(1)
        end

        %w(title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question_attr[attr.to_sym].to_json).at_path("question/#{attr}")
          end
        end
      end

      context 'invalid data' do
        let(:question_attr) do
          {
            title: 'New question',
            body: nil}
        end

        before { post '/api/v1/questions', params: {question: question_attr, format: :json, access_token: access_token.token} }

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end

        it 'returns question' do
          expect(response.body).to have_json_size(1).at_path('errors')
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end

end
