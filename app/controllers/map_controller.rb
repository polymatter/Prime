class MapController < ApplicationController
  def show
	@redx = params[:redx]
	@redy = params[:redy]
    @blux = params[:blux]
	@bluy = params[:bluy]
  end

end
