class TurnLogsController < ApplicationController
  # GET /turn_logs
  # GET /turn_logs.json
  def index
    @turn_logs = TurnLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @turn_logs }
    end
  end

  # GET /turn_logs/1
  # GET /turn_logs/1.json
  def show
    @turn_log = TurnLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @turn_log }
    end
  end

  # GET /turn_logs/new
  # GET /turn_logs/new.json
  def new
    @turn_log = TurnLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turn_log }
    end
  end

  # GET /turn_logs/1/edit
  def edit
    @turn_log = TurnLog.find(params[:id])
  end

  # POST /turn_logs
  # POST /turn_logs.json
  def create
    @turn_log = TurnLog.new(params[:turn_log])

    respond_to do |format|
      if @turn_log.save
        format.html { redirect_to @turn_log, notice: 'Turn log was successfully created.' }
        format.json { render json: @turn_log, status: :created, location: @turn_log }
      else
        format.html { render action: "new" }
        format.json { render json: @turn_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /turn_logs/1
  # PUT /turn_logs/1.json
  def update
    @turn_log = TurnLog.find(params[:id])

    respond_to do |format|
      if @turn_log.update_attributes(params[:turn_log])
        format.html { redirect_to @turn_log, notice: 'Turn log was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @turn_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turn_logs/1
  # DELETE /turn_logs/1.json
  def destroy
    @turn_log = TurnLog.find(params[:id])
    @turn_log.destroy

    respond_to do |format|
      format.html { redirect_to turn_logs_url }
      format.json { head :ok }
    end
  end
end
