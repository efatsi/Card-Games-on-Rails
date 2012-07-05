class PlayedTrick < ActiveRecord::Base
  attr_accessible :size, :trick_owner_id, :trick_owner_type
end
