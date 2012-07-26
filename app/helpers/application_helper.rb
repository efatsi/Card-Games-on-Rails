module ApplicationHelper
  
  # def progress_button(command)
  #   text = command
  #   path = command.downcase.gsub(" ", "_")
  #   action = self.send(path + "_game_path", @game)
  #   button_to text, action, {:remote => true, :form_class => "game-button", :class => "button"}
  # end
  # 
  def progress_button(command)
    path = self.send("game_" + command.gsub(" ","_") + "_path", @game)
    game_button(command, path)
  end
  
  def card_button(card, action)
    path = case action
    when :choose
      "game_choose_card_to_pass_path"
    when :play
      "game_play_one_card_path"
    end
    game_button(card.in_english, self.send(path, @game, :card => card))
  end
  
  def game_button(view, path)
    button_to view, path, {:remote => true, :form_class => "game-button", :class => "button"}
  end
  
end
