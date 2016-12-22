require 'acceptance/acceptance_helper'

feature 'Answer voting', %q{
  In order to change rating of answer
  As an authenticated user
  I'd like to vote a answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, user: author) }

  given(:question) { answer.question }
  given(:selector) { '.answer-wrapper' }

  it_behaves_like 'Vote resource'

end