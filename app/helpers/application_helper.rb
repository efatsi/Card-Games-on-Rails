module ApplicationHelper
  def game_button(text, path, form)
    button_to text, path, {:remote => true, :form_class => form, :class => "button"}
  end
end
