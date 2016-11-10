require 'acceptance/acceptance_helper'

feature 'Delete files', %q{
  In order to delete non-actual files
  As owner of files
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer_with_attachment, user: user) }

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path answer.question
    end
    scenario 'Authenticated user delete own file', js: true  do
      within '.answer-wrapper' do
        click_on 'Edit'
      end
      within '.edit_answer' do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'Authenticated user delete own file', js: true  do
      within '.answer-wrapper' do
        click_on 'Edit'
      end
      within '.edit_answer' do
        expect(page).to have_link 'Delete'
      end

      expect(page).to_not have_select '.answer-wrapper .attachments'
    end
  end

  scenario 'Authenticated user can\'t delete other user\'s files', js: true  do
    new_user = create(:user)
    sign_in(new_user)
    visit question_path answer.question
    within '.answer-wrapper' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user can\'t delete any file', js: true  do
    visit question_path answer.question
    within '.question-wrapper' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete'
    end
  end

end