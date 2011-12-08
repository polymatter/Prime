class MapController < ApplicationController
  def show
	@nodes = Node.find(:all)
	@units = Unit.find(:all)
  end

end
