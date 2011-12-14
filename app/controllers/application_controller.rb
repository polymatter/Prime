class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def current_player 
    @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end
  helper_method :current_player
end
