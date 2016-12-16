require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }

  let(:user) { create :user }

  permissions :create? do
    it 'grants access if user authorized' do
      expect(subject).to permit(user)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil)
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:answer))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:question, user: user))
    end

    it 'denies access if user is not admin' do
      expect(subject).to_not permit(User.new, create(:question, user: user))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end

  permissions :vote_up?, :vote_down? do
    it 'grants access if user is author of answer' do
      expect(subject).to_not permit(user, create(:question, user: user))
    end

    it 'grants access if user is not author of answer' do
      expect(subject).to permit(user, create(:question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end
end
