FactoryGirl.define do
  factory :user do
    sequence(:username) {|n|"user_#{n}" }
    password "secret"
    password_confirmation "secret"
    last_played_card_id = 0
  end
end