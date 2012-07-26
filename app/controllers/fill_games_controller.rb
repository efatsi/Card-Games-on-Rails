class FillGamesController < ApplicationController
  
  before_filter :assign_game

  def fill
    (4 - @game.players.length).times do |i|
      u = User.create(:username => "cp#{User.all.length}")
      Player.create(:user_id => u.id, :game_id => @game.id, :seat => @game.reload.next_seat, :is_human => false)
    end
    reload_game_page
  end
  
end
