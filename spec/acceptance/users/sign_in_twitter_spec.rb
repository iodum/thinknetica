require 'acceptance/acceptance_helper'

feature 'Siging in with twitter', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in with my twitter account
} do

  background { visit new_user_registration_path }

  scenario 'Twitter user tries to sign in' do
    email = 'new-user@test.com'
    clear_emails
    mock_auth_twitter

    click_on 'Sign in with Twitter'
    sleep 1

    expect(page).to have_content('Enter your e-mail')
    fill_in 'user_email', with: email
    click_on 'Finish sign up'

    open_email(email)
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed'

    click_on 'Sign in with Twitter'
    sleep 1
    expect(page).to have_content 'Log out'
  end

end