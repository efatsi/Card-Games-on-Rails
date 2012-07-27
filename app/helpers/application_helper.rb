module ApplicationHelper
  
  def progress_button(command, form = "immediate-reload")
    view = case command
    when "fill"
      "Start The Game"
    when "passing_set_ready"
      "Pass Your Cards"
    end
    path = self.send("game_" + command + "_path", @game)
    game_button(view, path, form)
  end
  
  def card_button(card, action, form = "immediate-reload")
    path = self.send("game_#{action}_path", @game, :card => card)
    game_button(card.in_english + " " + action, path, form)
  end
  
  def game_button(view, path, form )
    button_to view, path, {:remote => true, :form_class => form, :class => "button"}
  end
  
end