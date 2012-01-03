class MapController < ApplicationController
  def show
    @battle_reports = TurnLog.order('created_at DESC')
	@message_seperator = "|"
	@nodes = Node.find(:all)
	@units = Unit.find(:all)
	if current_player.present? 
	  @current_unit = current_player.units.first
	  @nodelinks = @current_unit.node.node_links
	end
  end

end
