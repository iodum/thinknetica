require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    subject { get :index, params: {q: '123456', resource: 'all'} }

    it 'call search method' do
      expect(Search).to receive(:search).with('123456', 'all')
      subject
    end

    it 'render index view' do
      subject
      expect(response).to render_template :index
    end
  end
end
