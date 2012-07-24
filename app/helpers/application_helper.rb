module ApplicationHelper
  # def game_button(text, path, form)
  #   button_to text, path, {:remote => true, :form_class => form, :class => "button"}
  # end
  
  def game_button(command)
    text = command
    path = command.downcase.gsub(" ", "_")
    action = self.send(path + "_game_path", @game)
    button_to text, action, {:remote => true, :form_class => "game-button", :class => "button"}
  end
end
