require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  describe 'the author' do

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

  describe 'other user' do

    context 'vote up' do
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

      it 'if try to vote differently, vote was canceled' do
        model.vote_up(user)
        model.reload
        model.vote_down(user)
        model.reload
        expect(model.rating).to eq 0
      end

      it 'if try to vote up, vote is added to common rating' do
        create_pair(:vote, votable: model, value: 1)
        model.vote_up(user)
        model.reload
        expect(model.rating).to eq 3
      end
    end

    context 'vote down' do

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

      it 'if try to vote down, vote is added to common rating' do
        create_pair(:vote, votable: model, value: 1)
        model.vote_up(user)
        model.reload
        expect(model.rating).to eq(3)
      end
    end

  end

  describe 'getting common rating' do
    it 'of positive value' do
      create_list(:vote, 5, votable: model, value: 1)
      expect(model.rating).to eq(5)
    end

    it 'of negative value' do
      create_list(:vote, 2, votable: model, value: -1)
      expect(model.rating).to eq(-2)
    end

    it 'of different value' do
      create_list(:vote, 5, votable: model, value: 1)
      create_list(:vote, 2, votable: model, value: -1)
      expect(model.rating).to eq(3)
    end
  end

  describe 'user has_votes?' do
    it 'has any vote at start' do
      expect(model.has_votes?(user)).to eq(false)
    end

    it 'has any vote' do
      create(:vote, votable: model, user: user)
      expect(model.has_votes?(user)).to eq(true)
    end

    it 'has positive vote' do
      create(:vote, votable: model, user: user)
      expect(model.has_votes?(user, 1)).to eq(true)
    end

    it 'has negative vote' do
      create(:vote, votable: model, user: user, value: -1)
      expect(model.has_votes?(user, -1)).to eq(true)
    end
  end

end
