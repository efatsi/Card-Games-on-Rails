class ApplicationController < ActionController::Base
  protect_from_forgery
  include SimplestAuth::Controller
end
