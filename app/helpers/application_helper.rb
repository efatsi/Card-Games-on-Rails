module ApplicationHelper
  
  def progress_button(command, form, the_class = "button")
    view = case command
    when "fill"
      "Start The Game"
    when "passing_set_ready"
      "Pass Your Cards"
    end
    path = self.send("game_" + command + "_path", @game)
    game_button(view, path, form, the_class)
  end
  
  def card_button(card, action, form, the_class = "button")
    path = self.send("game_#{action}_path", @game, :card => card)
    view = card.in_english
    game_button(view, path, form, the_class)
  end
  
  def game_button(view, path, form, the_class)
    button_to view, path, {:remote => true, :form_class => form, :class => the_class}
  end
  
  
  
  def player_can_pass?
    current_game.passing_time? && current_player.ready_to_pass?
  end
  
  def player_has_passed?
    current_player.has_passed?
  end
  
  def current_player
    current_user.try(:current_player_in_game, current_game)
  end
  
  def current_game
    Game.find(params[:id] || params[:game_id])  
  end
  
end