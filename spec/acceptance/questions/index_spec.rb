require 'acceptance/acceptance_helper'

feature 'View list of questions', %q{
  In order to find some interesting question
  As an user
  I want to be able to view list of questions
} do

  given!(:questions) { create_pair(:question) }

  scenario 'User views list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end

end