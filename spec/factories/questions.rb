FactoryGirl.define do
  factory :question do
    title "MyString"
    sequence(:body) { |n| "My new question #{n}" }
    user

    factory :question_with_answers do
      transient do
        answer_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answer_count, question: question)
      end
    end

    factory :question_with_attachment do
      after(:create) do |question|
        create(:attachment, attachable: question)
      end
    end

    factory :old_question do
      created_at Date.yesterday
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
