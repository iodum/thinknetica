require 'acceptance/acceptance_helper'

feature 'Delete files', %q{
  In order to delete non-actual files
  As owner of files
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_attachment, user: user) }



  describe 'Author' do
    before do
      sign_in(user)
      visit question_path question
    end

    describe 'in question show view' do
      scenario 'has link to delete own file', js: true  do
        within '.question-wrapper' do
          expect(page).to have_selector '.glyphicon-remove'
        end
      end

      scenario 'can delete own file', js: true  do
        attachment = question.attachments.first
        within '.question-wrapper .attachments' do
          click_on 'delete'
        end
        expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
      end
    end

    scenario 'has link to delete own file in question edit view', js: true  do
      within '.question-wrapper' do
        click_on 'Edit'
      end
      within '.edit_question' do
        expect(page).to have_link 'Delete'
      end
    end
  end

  describe 'Authenticated user' do
    before do
      new_user = create(:user)
      sign_in(new_user)
      visit question_path question
    end

    scenario 'can\'t delete other user\'s files', js: true  do
      within '.question-wrapper' do
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end

    scenario 'can\'t delete other user\'s files in edit form', js: true  do
      within '.question-wrapper' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_link 'Delete'
      end
    end
  end


  scenario 'Non-authenticated user can\'t delete any file', js: true  do
    visit question_path question
    within '.question-wrapper' do
      expect(page).to_not have_link 'Edit'
      within '.attachments' do
        expect(page).to_not have_link 'Delete'
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end
  end

end
