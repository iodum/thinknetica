require 'acceptance/acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  describe 'User' do
    before do
      data = attributes_for(:question)
      fill_in 'Title', with: data[:title]
      fill_in 'Body', with: data[:body]
    end

    scenario 'can add file', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'possible to add several files', js: true do
      within '.new_question' do
        expect(page).to have_link 'Add file'
      end
    end

    it_behaves_like 'Add files'

  end

end