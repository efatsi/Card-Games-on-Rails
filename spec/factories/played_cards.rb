FactoryGirl.define do
  factory :played_card do
    player_card
    trick
    position 0
  end
end