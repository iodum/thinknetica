shared_examples_for 'Vote resource' do
  scenario 'Unauthenticated user try to vote resource' do
    visit question_path(question)

    within "#{selector} .rating-wrapper" do
      expect(page).to_not have_selector 'vote-link'
    end
  end

  describe 'Author of resource' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'can view rating '  do
      within "#{selector} .rating-wrapper" do
        expect(page).to have_selector '.rating-result'
      end
    end

    scenario 'can\'t vote '  do
      within "#{selector} .rating-wrapper" do
        expect(page).to_not have_selector '.vote-link'
      end
    end
  end

  describe 'Authenticated user' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see link to vote' do
      within "#{selector} .rating-wrapper" do
        expect(page).to have_selector '.vote-link.v-up'
        expect(page).to have_selector '.vote-link.v-down'
        expect(page).to have_selector '.rating-result'
      end
    end

    scenario 'see link to vote' do
      within "#{selector} .rating-wrapper" do
        expect(page).to have_selector '.vote-link.v-up'
        expect(page).to have_selector '.vote-link.v-down'
        expect(page).to have_selector '.rating-result'
      end
    end

    scenario 'vote to up question', js: true do
      within "#{selector} .rating-wrapper" do
        find('.vote-link.v-up').click
        sleep 1
        within '.rating-result' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'vote to down question', js: true do
      within "#{selector} .rating-wrapper" do
        find('.vote-link.v-down').click
        sleep 1
        within '.rating-result' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'cancel voting', js: true do
      within "#{selector} .rating-wrapper" do
        find('.vote-link.v-down').click

        find('.vote-link.v-down').click

        within '.rating-result' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'rating is average of vote', js: true do
      create(:vote, votable: question)
      create(:vote, votable: question)

      within "#{selector} .rating-wrapper" do
        find('.vote-link.v-down').click
        sleep 1
        within '.rating-result' do
          expect(page).to have_content '1'
        end
      end
    end

  end

end