require 'acceptance/acceptance_helper'

feature 'Delete files', %q{
  In order to delete non-actual files
  As owner of files
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer_with_attachment, user: user) }

  given(:question) { answer.question }
  given(:attachable) { answer }
  given(:type) { 'answer' }

  it_behaves_like 'Delete files'

end