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
        expect(page).to have_selector '.glyphicon-remove'
      end
    end

    scenario 'Authenticated user delete own file', js: true  do
      within '.answer-wrapper .attachments' do
        click_on 'delete'
      end

      expect(page).to_not have_select '.answer-wrapper .attachments'
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

  describe 'Authenticated user' do
    before do
      new_user = create(:user)
      sign_in(new_user)
      visit question_path answer.question
    end

    scenario 'can\'t delete other user\'s files', js: true  do
      within '.answer-wrapper' do
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end

    scenario 'can\'t delete other user\'s files in edit form', js: true  do
      within '.answer-wrapper' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Non-authenticated user can\'t delete any file', js: true  do
    visit question_path answer.question
    within '.answer-wrapper' do
      expect(page).to_not have_link 'Edit'
      within '.attachments' do
        expect(page).to_not have_link 'Delete'
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end
  end

end