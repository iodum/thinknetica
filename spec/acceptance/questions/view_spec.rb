require 'rails_helper'

feature 'View detail of question', %q{
  In order to help with question
  As an user
  I want to be able to view detail of question
} do

  given!(:question) { create(:question_with_answers) }

  scenario 'User views detail of question' do
    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User views answers' do
    visit question_path question
    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

end