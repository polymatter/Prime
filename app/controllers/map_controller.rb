class MapController < ApplicationController
  def show
	@nodes = Node.find(:all)
  end

end
