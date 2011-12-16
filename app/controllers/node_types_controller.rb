class NodeTypesController < ApplicationController
  # GET /node_types
  # GET /node_types.json
  def index
    @node_types = NodeType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @node_types }
    end
  end

  # GET /node_types/1
  # GET /node_types/1.json
  def show
    @node_type = NodeType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @node_type }
    end
  end

  # GET /node_types/new
  # GET /node_types/new.json
  def new
    @node_type = NodeType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @node_type }
    end
  end

  # GET /node_types/1/edit
  def edit
    @node_type = NodeType.find(params[:id])
  end

  # POST /node_types
  # POST /node_types.json
  def create
    @node_type = NodeType.new(params[:node_type])

    respond_to do |format|
      if @node_type.save
        format.html { redirect_to @node_type, notice: 'Node type was successfully created.' }
        format.json { render json: @node_type, status: :created, location: @node_type }
      else
        format.html { render action: "new" }
        format.json { render json: @node_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /node_types/1
  # PUT /node_types/1.json
  def update
    @node_type = NodeType.find(params[:id])

    respond_to do |format|
      if @node_type.update_attributes(params[:node_type])
        format.html { redirect_to @node_type, notice: 'Node type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @node_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /node_types/1
  # DELETE /node_types/1.json
  def destroy
    @node_type = NodeType.find(params[:id])
    @node_type.destroy

    respond_to do |format|
      format.html { redirect_to node_types_url }
      format.json { head :ok }
    end
  end
end
