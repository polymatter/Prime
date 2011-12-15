class PlayersController < ApplicationController
  def new
    @player = Player.new
  end
  
  def create
    @player = Player.new(params[:player])
	if @player.save
	  redirect_to map_path, :notice => "Signed up!"
	else
	  render "new"
	end
  end
  
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @units }
    end
  end
end
