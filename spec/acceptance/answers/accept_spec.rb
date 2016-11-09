require 'acceptance/acceptance_helper'

feature 'Answer accepting', %q{
  In order to choose the best answer
  As an author of answer
  I'd like ot be able to accept some answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 'Unauthenticated user try to accept question' do
    visit question_path(question)
    expect(page).to_not have_link 'Accept'
  end


  describe 'Author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see link to accept for each answer' do
      question.answers.each do |answer|
        within "#answer-#{answer.id}" do
          expect(page).to have_link 'Accept'
        end
      end
    end

    scenario 'try to accept answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Accept'
        expect(page).to have_content 'Accepted!'
      end
    end

    scenario 'try to change accepting answer', js: true do
      within "#answer-#{answer2.id}" do
        click_on 'Accept'
        expect(page).to have_content 'Accepted!'
      end

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Accepted!'
      end
    end

    scenario 'accepting answer is showed first', js: true do
      answer.accept
      visit question_path(question)

      expect(first('.answer-wrapper')).to have_content 'Accepted!'
      expect(first('.answer-wrapper')).to have_content answer.body

      within "#answer-#{answer2.id}" do
        click_on 'Accept'
        sleep 1
      end
      expect(first('.answer-wrapper')).to have_content answer2.body
    end

  end

  scenario 'Try to accept answer for other user\'s question' do
    new_user = create(:user)
    sign_in new_user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Accept'
    end
  end

end