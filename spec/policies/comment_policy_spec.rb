require 'rails_helper'

RSpec.describe CommentPolicy do
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
end
