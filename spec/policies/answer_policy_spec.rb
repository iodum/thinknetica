require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { create :user }

  permissions :create? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true))
    end

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
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not admin' do
      expect(subject).to_not permit(User.new, create(:answer, user: user))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :accept? do
    it 'grants access if user is author of question' do
      question = create(:question, user: user)
      expect(subject).to permit(user, create(:answer, question: question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :vote_up?, :vote_down? do
    it 'grants access if user is author of answer' do
      expect(subject).to_not permit(user, create(:answer, user: user))
    end

    it 'grants access if user is not author of answer' do
      expect(subject).to permit(user, create(:answer))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

end
