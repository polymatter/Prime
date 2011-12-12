class NodeLinksController < ApplicationController
  # GET /node_links
  # GET /node_links.json
  def index
    @node_links = NodeLink.order("node_id", "linked_node_id")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @node_links }
    end
  end

  # GET /node_links/1
  # GET /node_links/1.json
  def show
    @node_link = NodeLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @node_link }
    end
  end

  # GET /node_links/new
  # GET /node_links/new.json
  def new
    @node_link = NodeLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @node_link }
    end
  end

  # GET /node_links/1/edit
  def edit
    @node_link = NodeLink.find(params[:id])
  end

  # POST /node_links
  # POST /node_links.json
  def create
    @node_link = NodeLink.new(params[:node_link])

    respond_to do |format|
      if @node_link.save
        format.html { redirect_to @node_link, notice: 'Node link was successfully created.' }
        format.json { render json: @node_link, status: :created, location: @node_link }
      else
        format.html { render action: "new" }
        format.json { render json: @node_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /node_links/1
  # PUT /node_links/1.json
  def update
    @node_link = NodeLink.find(params[:id])

    respond_to do |format|
      if @node_link.update_attributes(params[:node_link])
        format.html { redirect_to @node_link, notice: 'Node link was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @node_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /node_links/1
  # DELETE /node_links/1.json
  def destroy
    @node_link = NodeLink.find(params[:id])
    @node_link.destroy

    respond_to do |format|
      format.html { redirect_to node_links_url }
      format.json { head :ok }
    end
  end
end
