module ApplicationHelper
  
  def progress_button(command, form = "game-button")
    path = self.send("game_" + command.gsub(" ","_") + "_path", @game)
    game_button(command, path, form)
  end
  
  def card_button(card, action, form = "play-card-button")
    path = self.send("game_#{action}_path", @game, :card => card)
    game_button(card.in_english, path, form)
  end
  
  def game_button(view, path, form)
    button_to view, path, {:remote => true, :form_class => form, :class => "button"}
  end
  
end
