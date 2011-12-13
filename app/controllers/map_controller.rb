class MapController < ApplicationController
  def show
	@nodes = Node.find(:all)
	@units = Unit.find(:all)
	@current_unit = Node.find(1)
  end

end
