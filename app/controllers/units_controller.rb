class UnitsController < ApplicationController
  def move
    @unit = Unit.find(params[:unit])
	@node = Node.find(params[:node])
    notice = @unit.name + ' can not move to ' + @node.name + ' from ' + @unit.node.name

    respond_to do |format|
      if @unit.node.linked_nodes.keep_if {|dest| dest.id == @node.id }.count > 0
        if @unit.update_attributes({ "node_id" => params[:node] })
          format.html { redirect_to map_path, notice: 'Unit was successfully moved.' }
          format.json { head :ok }
        else
          format.html { redirect_to units_path }
          format.json { render json: @unit.errors, status: :unprocessable_entity }
        end
	  else
	    format.html { redirect_to map_path,
          notice: notice}
		format.json { render json: notice,
		  status: :unprocessable_entity }
	  end
    end
	
  end

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all

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
