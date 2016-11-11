FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "My new answer #{n}" }
    question
    user
    accepted false

    factory :answer_with_attachment do
      after(:create) do |answer|
        create(:attachment, attachable: answer)
      end
    end
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
