class Deck < ActiveRecord::Base
  
  has_many :cards
  
end
