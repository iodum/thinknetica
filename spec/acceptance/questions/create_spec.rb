require 'acceptance/acceptance_helper'

feature 'Create question', %q{
  In order to get answer
  As an authenticated user
  I want to be able to ask the question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question with valid data' do
    sign_in(user)
    data = attributes_for(:question)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: data[:title]
    fill_in 'Body', with: data[:body]
    click_on 'Create'

    expect(page).to have_content data[:title]
    expect(page).to have_content data[:body]
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Authenticated user create the question with invalid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'Question'
    click_on 'Create'

    expect(page).to have_content 'Question could not be created'

  end

  scenario 'Non-authenticated user create the question' do
    visit '/questions'

    expect(page).to_not have_content 'Ask question'
  end

  context 'multiple session' do
    scenario 'question appears on another user\'s page' do
      data = attributes_for(:question)

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do

        click_on 'Ask question'
        fill_in 'Title', with: data[:title]
        fill_in 'Body', with: data[:body]
        click_on 'Create'

        expect(page).to have_content data[:title]
        expect(page).to have_content data[:body]
      end

      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_content data[:title]
      end
    end
  end
end