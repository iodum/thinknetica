require 'acceptance/acceptance_helper'

feature 'Destroy questions', %q{
  In order to delete non-actual question
  As an user
  I want to be able to destroy question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user destroys own question' do
    sign_in(question.user)
    visit question_path question

    within '.question-wrapper' do
      click_on 'Delete'
    end

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user can\'t destroy other user\'s question' do
    sign_in(user)
    visit question_path question
    within '.question-wrapper' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user can\'t destroy any questions' do
    visit question_path question
    within '.question-wrapper' do
      expect(page).to_not have_link 'Delete'
    end
  end

end