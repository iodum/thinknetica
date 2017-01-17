require 'acceptance/acceptance_helper'
require 'support/sphinx'

feature 'Search', %q{
  In order to be able to find information
  As an user
  I want be able to search by resources
} do

  given!(:question1) { create(:question, title: 'needed question title') }
  given!(:question2) { create(:question, title: 'question title 2') }
  given!(:answer1) { create(:answer, body: 'needed answer body') }
  given!(:answer2) { create(:answer, body: 'answer body 2') }
  given!(:comment1) { create(:comment, commentable: question1, text: 'needed question\'s comment') }
  given!(:comment2) { create(:comment, commentable: answer1, text: 'needed answer\'s comment') }
  given!(:user1) { create(:user, email: 'needed@example.com') }
  given!(:user2) { create(:user, email: 'newuser@example.com') }


  context 'when query in not empty' do
    before do
      index
      visit searches_path
      fill_in 'q', with: 'needed'
    end

    scenario 'searching for all', :js do
      click_button 'Search'

      expect(page).to have_content question1.title
      expect(page).to have_content answer1.body
      expect(page).to have_content comment2.text
      expect(page).to have_content comment1.text
      expect(page).to have_content user1.email

      expect(page).to_not have_content user2.email
      expect(page).to_not have_content question2.title
      expect(page).to_not have_content answer2.body
    end

    scenario 'searching for questions', :js do
      select 'question', from: 'resource'
      click_button 'Search'

      expect(page).to have_content question1.title

      expect(page).to_not have_content answer1.body
      expect(page).to_not have_content comment2.text
      expect(page).to_not have_content user1.email
    end

    scenario 'searching for answers', :js do
      select 'answer', from: 'resource'
      click_button 'Search'

      expect(page).to have_content answer1.body

      expect(page).to_not have_content question1.title
      expect(page).to_not have_content comment2.text
      expect(page).to_not have_content user1.email
    end

    scenario 'searching for comments', :js do
      select 'comment', from: 'resource'
      click_button 'Search'

      expect(page).to have_content comment2.text
      expect(page).to have_content comment1.text

      expect(page).to_not have_content question1.title
      expect(page).to_not have_content answer1.body
      expect(page).to_not have_content user1.email
    end

    scenario 'searching for users', :js do
      select 'user', from: 'resource'
      click_button 'Search'

      expect(page).to have_content user1.email

      expect(page).to_not have_content user2.email
      expect(page).to_not have_content question1.title
      expect(page).to_not have_content answer1.body
      expect(page).to_not have_content comment2.text
    end
  end

end