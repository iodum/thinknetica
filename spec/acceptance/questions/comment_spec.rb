require 'acceptance/acceptance_helper'

feature 'Commenting question', %q{
  In order to ask some details of question
  As an authenticated user
  I'd like to comment a question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  given(:type) { 'question' }

  it_behaves_like 'Add comments'

end