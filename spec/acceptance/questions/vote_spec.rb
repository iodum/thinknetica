require 'acceptance/acceptance_helper'

feature 'Question voting', %q{
  In order to change rating of question
  As an authenticated of question
  I'd like to vote a question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  given(:selector) { '' }

  it_behaves_like 'Vote resource'

end