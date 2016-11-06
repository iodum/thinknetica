require 'acceptance/acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    within '.question-wrapper' do
      expect(page).to_not have_link 'Edit'
    end
  end


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.question-wrapper' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      within '.question-wrapper' do
        fill_in 'Title', with: 'edited question'
        fill_in 'Body', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

  end

  scenario 'try to edit other user\'s question' do
    new_user = create(:user)
    sign_in new_user
    visit question_path(question)

    within '.question-wrapper' do
      expect(page).to_not have_link 'Edit'
    end
  end

end