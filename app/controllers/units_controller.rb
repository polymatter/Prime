class UnitsController < ApplicationController
  http_basic_authenticate_with :name => "god", :password => "god", :except => [ :move, :cancel_move ]
  
  def cancel_move
    @unit = current_player.units.find(params[:unit]) if current_player
	
	respond_to do |format|
	  if !@unit
	     format.html { redirect_to map_path, notice: 'Player probable does not have permission to cancel the move order' }
         format.json { render json: 'permission denied', status: :unprocessable_entry }
	  elsif @unit.stop
        format.html { redirect_to map_path, notice: "#{@unit.name} will stay at present location" }
        format.json { head :ok }
      else	  
        format.html { redirect_to map_path, notice: 'Database error, maybe node_link_id has been linked with node_links in the database?' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }	  
	  end
	end
  end
  
  def move
    @unit = current_player.units.find(params[:unit]) if current_player
	@nodelink = NodeLink.find(params[:nodelink])
	
	if @unit && @nodelink
	  move_order = "#{@unit.name} will move from #{@nodelink.node.name} to #{@nodelink.linked_node.name}"
	end
	
    respond_to do |format|
	  if !(@unit && @nodelink)
	    # node :unit and :node must exist otherwise it would not route here
	    format.html { redirect_to map_path, notice: 'Player probably does not have permission to move unit (' + params[:unit] + ') along nodelink (' + params[:nodelink] + ')'}
	    format.json { render json: 'permission denied', status: :unprocessable_entry }
	  elsif @unit.node == @nodelink.node
        if @unit.update_attributes({:node_link_id => @nodelink.id })
          format.html { redirect_to map_path, notice: 'Set order: ' + move_order }
          format.json { head :ok }
        else
          format.html { redirect_to map_path, notice: 'DB fail to save the order: ' + move_order }
          format.json { render json: @unit.errors, status: :unprocessable_entity }
        end
	  else
	    format.html { redirect_to map_path, notice: 'No direct link between nodes to allow to move ' + move_order}
		format.json { render json: @unit.errors, status: :unprocessable_entity }
	  end
    end
	
  end

  # GET /units
  # GET /units.json
  def index
    @units = Unit.order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @units }
    end
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @unit = Unit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unit }
    end
  end

  # GET /units/new
  # GET /units/new.json
  def new
    @unit = Unit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @unit }
    end
  end

  # GET /units/1/edit
  def edit
    @unit = Unit.find(params[:id])
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(params[:unit])

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render json: @unit, status: :created, location: @unit }
      else
        format.html { render action: "new" }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /units/1
  # PUT /units/1.json
  def update
    @unit = Unit.find(params[:id])

    respond_to do |format|
      if @unit.update_attributes(params[:unit])
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy

    respond_to do |format|
      format.html { redirect_to units_url }
      format.json { head :ok }
    end
  end
end
