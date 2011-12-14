class MapController < ApplicationController
  def show
	@nodes = Node.find(:all)
	@units = Unit.find(:all)
	@current_unit ||= current_player.units.first if current_player
  end

end
