require 'rails_helper'

RSpec.describe AttachmentPolicy do
  subject { described_class }

  let(:user) { create :user }
  let(:answer) { create(:answer_with_attachment, user: user) }

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), answer.attachments.first)
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, answer.attachments.first)
    end

    it 'denies access if user is not admin' do
      expect(subject).to_not permit(User.new, answer.attachments.first)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, answer.attachments.first)
    end
  end
end
