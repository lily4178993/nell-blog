class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.first
  end

  # Make current_user available in controller views
  helper_method :current_user
end
