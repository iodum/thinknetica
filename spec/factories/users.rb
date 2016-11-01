FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '87654321'
    password_confirmation '87654321'
  end
end
