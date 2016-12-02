FactoryGirl.define do
  factory :comment do
    commentable nil
    user nil
    text "MyText"
  end

  factory :invalid_comment, class: 'Comment' do
    text nil
  end
end
