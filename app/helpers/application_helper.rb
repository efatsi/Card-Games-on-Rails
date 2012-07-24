module ApplicationHelper
  # def game_button(text, path, form)
  #   button_to text, path, {:remote => true, :form_class => form, :class => "button"}
  # end
  
  def game_button(command, form = nil)
    text = command
    path = command.downcase.gsub(" ", "_")
    form ||= command.downcase.gsub(" ", "-")
    action = self.send(path + "_game_path", @game)
    button_to text, action, {:remote => false, :form_class => form, :class => "button"}
  end
end
