class MapController < ApplicationController
  def show
	@nodes = Node.find(:all)
	@units = Unit.find(:all)
	if current_player.present? 
	  @current_unit = current_player.units.first
	  @nodelinks = @current_unit.node.node_links
	end
  end

end
