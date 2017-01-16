require 'acceptance/acceptance_helper'

feature 'Subscription', %q{
   In order to get email about new answers
   As a user
   I want to subscribe to question
 } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  scenario 'Non-authenticated user tries to subscribe or unsubscribe' do
    visit question_path(question)

    expect(page).to_not have_link 'subscribe'
    expect(page).to_not have_link 'unsubscribe'
  end

  context 'Authenticated user' do
    scenario 'Try to subscribes and unsubscribes', js: true do
      sign_in(user)
      visit question_path(question)

      click_link 'subscribe'
      clear_emails
      create(:answer, question: question, body: 'Answer')
      open_email(user.email)

      expect(current_email).to have_content('Answer')

      click_link 'unsubscribe'
      clear_emails
      create(:answer, question: question, body: 'Answer new')
      open_email(user.email)

      expect(current_email).to be_nil
      expect(page).to_not have_link 'unsubscribe'
      expect(page).to have_link 'subscribe'
    end

    scenario 'Author unsubscribes his question', js: true do
      sign_in(user)
      visit question_path(user_question)

      click_link 'unsubscribe'

      expect(page).to_not have_link 'unsubscribe'
      expect(page).to have_link 'subscribe'
    end
  end
end