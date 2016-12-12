require 'acceptance/acceptance_helper'

feature 'Siging in with facebook', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in with my facebook account
} do

  background { visit new_user_registration_path }

  scenario 'Facebook user tries to sign in' do
    mock_auth_facebook
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Successfully authenticated from Facebook account')
  end

end