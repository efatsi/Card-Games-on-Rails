FactoryGirl.define do
  factory :user do
    sequence(:username) {|n|"user_#{n}" }
    password "secret"
    password_confirmation "secret"
  end
end