require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe 'author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'return true if user is author' do
      expect(user).to be_author_of(question)
    end

    it 'return false if user is not author' do
      expect(user).to_not be_author_of(create(:question))
    end
  end
end