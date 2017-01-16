require 'rails_helper'

RSpec.describe SubscriptionPolicy do
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

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:subscription))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:subscription, user: user))
    end

    it 'denies access if user is not admin' do
      expect(subject).to_not permit(User.new, create(:subscription, user: user))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:subscription))
    end
  end
end
