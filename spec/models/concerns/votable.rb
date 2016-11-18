require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  context 'the author' do

    it 'can\'t vote for his' do
      model.vote_up(model.user)
      model.reload
      expect(model.rating).to eq 0
    end

    it 'the author can\'t vote down' do
      model.vote_down(model.user)
      model.reload
      expect(model.rating).to eq 0
    end

  end

  context 'other user' do
    it 'can vote up' do
      model.vote_up(user)
      model.reload
      expect(model.rating).to eq 1
    end

    it 'if try to vote up twice, vote was canceled' do
      model.vote_up(user)
      model.reload
      model.vote_up(user)
      model.reload
      expect(model.rating).to eq 0
    end

    it 'can vote down' do
      model.vote_down(user)
      model.reload
      expect(model.rating).to eq -1
    end

    it 'if try to vote down twice, vote was canceled' do
      model.vote_down(user)
      model.reload
      model.vote_down(user)
      model.reload
      expect(model.rating).to eq 0
    end
  end
end
