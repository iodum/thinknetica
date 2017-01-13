require 'acceptance/acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe 'User' do
    before do
      data = attributes_for(:answer)
      fill_in 'Answer', with: data[:body]
    end

    scenario 'can add file', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'possible to add several files', js: true do
      within '.new_answer' do
        expect(page).to have_link 'Add file'
      end
    end

    it_behaves_like 'Add files'

  end

end