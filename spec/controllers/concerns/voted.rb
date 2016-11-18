require 'rails_helper'

shared_examples 'voted' do
  sign_in_user
  type = described_class.controller_name.singularize.to_sym
  let(:item) { create(type) }
  let(:users_item) { create(type, user: @user) }

  describe 'PATCH #vote_up' do

    context 'if user is author of item' do
      it 'can\'t add vote' do
        expect { patch :vote_up, params: {id: users_item.id}, format: :js }.to_not change(Vote, :count)
      end
    end

    context 'if user is not author of item' do
      it 'can add vote' do
        expect { patch :vote_up, params: {id: item.id}, format: :js }.to change(item.votes, :count).by(1)
      end
    end
  end
end
