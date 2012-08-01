class ReloadsController < ApplicationController

  def reload_all
    reload_partial
  end
  
  def reload_trick
    reload_partial("shared/previous_trick")
  end
  
end
