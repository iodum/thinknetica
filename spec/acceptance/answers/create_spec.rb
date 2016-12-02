require 'acceptance/acceptance_helper'

feature 'Create answer', %q{
  In order to help
  As an authenticated user
  I want to be able to add the answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create the answer with valid data', js: true do
    data = attributes_for(:answer)
    view_question(user, question)
    fill_in 'Answer', with: data[:body]
    click_on 'Add'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content data[:body]
    end
  end

  scenario 'Authenticated user create the answer with invalid data', js: true do
    view_question(user, question)
    fill_in 'Answer', with: ''
    click_on 'Add'

    expect(page).to have_content 'Body is too short'
  end

  scenario 'Non-authenticated user create the answer' do
    visit question_path question
    expect(page).to_not have_field 'Answer'
  end

  feature 'Multiple sessions', js: true do
    scenario 'answer appears on another user\'s page' do
      data = attributes_for(:answer)

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Answer', with: data[:body]
        click_on 'Add'

        within '.answers' do
          expect(page).to have_content data[:body]
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content data[:body]
        end
      end
    end
  end
end