shared_examples_for 'Delete files' do
  describe 'Author' do
    before do
      sign_in(user)
      visit question_path question
    end

    describe 'in show view' do
      scenario 'has link to delete own file', js: true  do
        within ".#{type}-wrapper" do
          expect(page).to have_selector '.glyphicon-remove'
        end
      end

      scenario 'can delete own file', js: true  do
        attachment = attachable.attachments.first
        within ".#{type}-wrapper .attachments" do
          click_on 'delete'
        end
        expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
      end
    end

    scenario 'has link to delete own file in edit view', js: true  do
      within ".#{type}-wrapper" do
        click_on 'Edit'
      end
      within ".edit_#{type}" do
        expect(page).to have_link 'Delete'
      end
    end
  end

  describe 'Authenticated user' do
    before do
      new_user = create(:user)
      sign_in(new_user)
      visit question_path question
    end

    scenario 'can\'t delete other user\'s files', js: true  do
      within ".#{type}-wrapper" do
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end

    scenario 'can\'t delete other user\'s files in edit form', js: true  do
      within ".#{type}-wrapper" do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Non-authenticated user can\'t delete any file', js: true  do
    visit question_path question
    within ".#{type}-wrapper" do
      expect(page).to_not have_link 'Edit'
      within '.attachments' do
        expect(page).to_not have_link 'Delete'
        expect(page).to_not have_selector '.glyphicon-remove'
      end
    end
  end

end