FactoryGirl.define do
  factory :player do
    game
    user
    seat 0
    total_score 0
  end
end