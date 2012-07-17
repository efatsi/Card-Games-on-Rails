module MakeCards
  
  def create_cards
    %w(club heart spade diamond).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
        card = FactoryGirl.create(:card, :suit => suit, :value => value.to_s)
      end
    end
  end

end