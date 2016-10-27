require 'rails_helper'

feature 'Create question', %q{
  In order to get answer
  As an authenticated user
  I want to be able to ask the question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question with valid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'

  end

  scenario 'Authenticated user create the question with invalid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'Question'
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank'

  end

  scenario 'Non-authenticated user create the question' do
    visit '/questions'
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end