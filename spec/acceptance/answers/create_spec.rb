require 'rails_helper'

feature 'Create answer', %q{
  In order to help
  As an authenticated user
  I want to be able to add the answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create the answer with valid data' do
    view_question(user, question)
    fill_in 'Answer', with: 'Answer'
    click_on 'Add'

    expect(page).to have_content 'Your answer successfully added.'

  end

  scenario 'Authenticated user create the answer with invalid data' do
    view_question(user, question)
    fill_in 'Answer', with: ''
    click_on 'Add'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user create the answer' do
    visit question_path question
    expect(page).to_not have_field 'Answer'
  end

  scenario 'Authenticated user can add answer on question page' do
    view_question(user, question)
    expect(page).to have_field 'Answer'
    expect(page).to have_button 'Add'
  end
end