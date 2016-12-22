shared_examples_for 'Add comments' do
  scenario 'Unauthenticated user try to comment' do
    visit question_path(question)

    within ".#{type}-wrapper .comments-wrapper" do
      expect(page).to_not have_selector '.edit-comment-link'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within ".#{type}-wrapper" do
        expect(page).to have_link 'Add comment'
      end
    end

    scenario 'try to edit his answer', js: true do
      within ".#{type}-wrapper" do
        click_on 'Add comment'

        fill_in 'Your comment', with: 'New comment'
        click_on 'Add'

        expect(page).to have_content 'New comment'
      end
    end

    scenario 'create the comment with invalid data', js: true do
      within ".#{type}-wrapper" do
        click_on 'Add comment'

        fill_in 'Your comment', with: ''
        click_on 'Add'
      end

      expect(page).to have_content 'Text is too short'
    end

  end

  describe 'Multiple sessions', js: true do
    scenario 'comment appears on another user\'s page' do
      data = attributes_for(:comment)

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".#{type}-wrapper" do
          click_on 'Add comment'

          fill_in 'Your comment', with: data[:text]
          click_on 'Add'
        end

        within ".#{type}-wrapper" do
          expect(page).to have_content data[:text]
        end
      end

      Capybara.using_session('guest') do
        within ".#{type}-wrapper" do
          expect(page).to have_content data[:text]
        end
      end
    end
  end

end


