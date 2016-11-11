require 'acceptance/acceptance_helper'

feature 'Delete files', %q{
  In order to delete non-actual files
  As owner of files
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_attachment, user: user) }



  describe 'Author' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'Authenticated user delete own file', js: true  do
      within '.question-wrapper' do
        expect(page).to have_selector '.glyphicon-remove'
      end
    end

    scenario 'Authenticated user delete own file', js: true  do
      within '.question-wrapper .attachments' do
        click_on 'delete'
      end

      expect(page).to_not have_select '.question-wrapper .attachments'
    end

    scenario 'Authenticated user delete own file in edit form', js: true  do
      within '.question-wrapper' do
        click_on 'Edit'
      end
      within '.edit_question' do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'Authenticated user delete own file in edit form', js: true  do
      within '.question-wrapper' do
        click_on 'Edit'
      end
      within '.edit_question' do
        click_on 'Delete'
      end

      expect(page).to_not have_select '.question-wrapper .attachments'
    end
  end

  describe 'Authenticated user' do
    before do
      new_user = create(:user)
      sign_in(new_user)
      visit question_path question
    end

    scenario 'can\'t delete other user\'s files', js: true  do
      within '.question-wrapper' do
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end

    scenario 'can\'t delete other user\'s files in edit form', js: true  do
      within '.question-wrapper' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_link 'Delete'
      end
    end
  end


  scenario 'Non-authenticated user can\'t delete any file', js: true  do
    visit question_path question
    within '.question-wrapper' do
      expect(page).to_not have_link 'Edit'
      within '.attachments' do
        expect(page).to_not have_link 'Delete'
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end
  end

end




# require 'acceptance/acceptance_helper'
#
# feature 'Delete files', %q{
#   In order to delete non-actual files
#   As owner of files
#   I want to be able to delete it
# } do
#
#   given(:user) { create(:user) }
#   given!(:question) { create(:question_with_attachment, user: user) }
#
#   describe 'Author' do
#     before do
#       sign_in(user)
#       visit question_path question
#     end
#
#
#     scenario 'Authenticated user delete own file', js: true  do
#       within '.question-wrapper' do
#         expect(page).to have_selector '.glyphicon-remove'
#       end
#     end
#
#     scenario 'Authenticated user delete own file in edit form', js: true  do
#       within '.question-wrapper' do
#         first('.glyphicon-remove').click
#       end
#
#       expect(page).to_not have_select '.question-wrapper .attachments'
#     end
#
#     scenario 'Authenticated user delete own file in edit form', js: true  do
#       within '.question-wrapper' do
#         click_on 'Edit'
#       end
#       within '.edit_question' do
#         expect(page).to have_link 'Delete'
#       end
#     end
#
#     scenario 'Authenticated user delete own file in edit form', js: true  do
#       within '.question-wrapper' do
#         click_on 'Edit'
#       end
#       within '.edit_question' do
#         expect(page).to have_link 'Delete'
#       end
#
#       expect(page).to_not have_select '.question-wrapper .attachments'
#     end
#   end
#
#   describe 'Authenticated user ' do
#     before do
#       new_user = create(:user)
#       sign_in(new_user)
#       visit question_path question
#     end
#     scenario 'can\'t delete other user\'s files', js: true  do
#       within '.question-wrapper' do
#         expect(page).to_not have_link 'Edit'
#         expect(page).to_not have_link 'Delete'
#       end
#     end
#
#     scenario 'can\'t delete other user\'s files', js: true  do
#       within '.question-wrapper' do
#         expect(page).to_not have_selector '.glyphicon-remove'
#       end
#     end
#
#   end
#
#   scenario 'Non-authenticated user can\'t delete any file', js: true  do
#     visit question_path question
#     within '.question-wrapper' do
#       expect(page).to_not have_link 'Edit'
#       expect(page).to_not have_link 'Delete'
#     end
#   end

# end