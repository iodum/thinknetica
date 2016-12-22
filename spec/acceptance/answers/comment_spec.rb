require 'acceptance/acceptance_helper'

feature 'Commenting answer', %q{
  In order to ask some details of answer
  As an authenticated user
  I'd like to comment a answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  given(:type) { 'answer' }

  it_behaves_like 'Add comments'

end