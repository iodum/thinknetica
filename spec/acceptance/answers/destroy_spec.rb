require 'acceptance/acceptance_helper'

feature 'Destroy answers', %q{
  In order to delete non-actual answer
  As an user
  I want to be able to destroy answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user destroys own answer', js:true do
    sign_in(answer.user)
    visit question_path answer.question

    within '.answers' do
      click_on 'Delete'
    end

    expect(current_path).to eq question_path answer.question
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user can\'t destroy other user\'s answer', js:true do
    sign_in(user)
    visit question_path answer.question
    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user can\'t destroy any answer', js:true do
    visit question_path answer.question
    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end

end