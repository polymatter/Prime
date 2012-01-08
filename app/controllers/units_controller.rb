class UnitsController < ApplicationController
  http_basic_authenticate_with :name => "god", :password => "god", :except => [ :move, :cancel_move ]

  def turn
	battle_reports = []
	
	#any moving units reach their destination.
	#we do not set them to stationary yet though, just in case they retreat
	Unit.all.select { |unit| unit.moving? }.each { |unit| unit.move_with_undo }
	
	# resolve all conflict at each node
    Node.all.each do |node|
	  # if there are both human and computer units at this node, then resolve their fight
	  if node.has_human_units && node.has_computer_units
	    battles = node.human_units.zip(node.computer_units)
		# battles is a pairing of human units and computer units. 
		# this way each human or computer unit will only fight a battle against another unit once.
		# eg battles = [[human_unit, computer_unit],[human_unit, computer_unit], [human_unit, nil]]
        battles.each do |battle|
		  human_unit    = battle[0]
		  computer_unit = battle[1]
		  
		  # there is no battle if either unit is nil
		  if human_unit && computer_unit
		    # decide on who is attacker, and who is the defender
		    attacker = node.is_enemy(human_unit) ? human_unit    : computer_unit
		    defender = node.is_enemy(human_unit) ? computer_unit : human_unit
		  
		    # resolve the fight
		    battle_report = attacker.attack(defender)
			if battle_reports === []
			  battle_reports << battle_report
			else 
			  battle_reports << message_seperator << battle_report
			end
		  end
		end
	  end
	  
	  # if after unit battles, there are enemy units on this node, resolve fighting these enemy units
	  if node.has_friendly_units
	    node.enemy_units.each {|unit| unit.retreat }
	  else
	    node_captured = false
	    node.enemy_units.each do |unit|
	      if !node_captured
		    node.fight_unit(unit)
		  end
	    end
	  end
	  
	end
	
	#make all units stationary
	Unit.all.each { |unit| unit.stationary }
	
	respond_to do |format|
      format.html { redirect_to map_path, notice: 'Turn update complete' }
      format.json { head :ok }
	end
	
  end
  
  # having a seperate method for cancelling a move means:
  # 1. no need to sprinkle checks in move method for if node_link == 0 and is therefore an invalid nodelink
  # these checks are kind of strange since why are we setting to an invalid node_link? answer: to represent
  # a unit that is not moving. this is a different state transition and should be handled seperately
  # 2. if decided later to have a boolean "travelling?" column or some other way of representing the unit
  # not moving, then this way is easier to change since we can assume in move that only valid node_links are
  # given and we can assume in cancel_move that we don't care about the node_link
  def cancel_move
    @unit = current_player.units.find(params[:unit]) if current_player
	
	respond_to do |format|
	  if !@unit
	     format.html { redirect_to map_path, notice: 'Player probable does not have permission to cancel the move order' }
         format.json { render json: 'permission denied', status: :unprocessable_entry }
	  elsif @unit.update_attributes({:node_link_id => 0})
        format.html { redirect_to map_path, notice: @unit.name + ' will stay at present location' }
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
