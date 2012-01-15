class Unit < ActiveRecord::Base
  extend Battle
  
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link between nodes that a unit is traversing
  has_many :turn_logs
  
  @@human_home_node_id = 1 #respawn location for human units
  @@computer_home_node_id = 5 #respawn location for computer units
  
  # used to ensure a unit doesn't move (since a unit will never be at node_id 0)
  def stop
    self.update_attributes({ :node_link_id => 0})
  end

  def retreat
    # unit was defending
    if !moving?
	  strongest_friendly_neighbour = location.neighbours.inject {|node1, node2| node1.strength > node2.strength ? node1 : node2}
	  # able to retreat to friendly node
	  if !strongest_friendly_neighbour.nil?
	    dest = strongest_friendly_neighbour
	    dest_id = strongest_friendly_neighbour.id
		verb = 'retreated to'
	  # surrounded, no friendly neighbouring node to retreat to
	  else
	    # respawn destination
	    dest_id = self.human? ? @@human_home_node_id : @@computer_home_node_id
		verb = 'respawned at'
	  end
	# unit is retreating after attacking
	else
	  # retreat back to the node from where this unit came from
	  dest = move_path.origin
	  dest_id = move_path.origin.id
	  verb = 'scattered back to'
	end
	
	dest ||= Node.find(dest_id)
	msg = "#{name} #{verb} #{dest.name}"
	log('retreat',msg)
	self.update_attributes({ :node_id => dest_id })
	
	# units retreating after a battle, can not then move	
	self.stop
  end
  
  def log(code,msg)
    l = TurnLog.new
	l.update_attributes({ :notes => msg, :unit_id => self.id, :desc => code, :when => Time.now })
  end
  
  def move(node_id = destination.id, verb = 'moved to')
    msg = "#{name} #{verb} #{Node.find(node_id).name}"
	log('move',msg)
    self.update_attributes({ :node_id => node_id})
  end
  
  def move_order(new_move_path)
    if new_move_path && (new_move_path.origin == self.location)
      msg = "#{name} will move to #{new_move_path.destination.name} from #{self.location}"
	  log('move_order', msg)
	  self.update_attributes ({ :node_link_id => new_move_path.id })
	else
	  nil #indicate that move_order failed
	end
  end
  
  def enemy?(unit)
    # ^ is the XOR operator
    self.human? ^ unit.human?
  end
    
  # a unit is moving if the unit is not yet at its destination
  # a stationary unit is also modelled as one with a node_link_id of 0 (since a unit will never be at node_id 0)
  def moving?
    move_path && (self.location != move_path.destination)
  end
    
  def self.move_all_human
    move_all true
  end
  
  def self.move_all_computer
    move_all false
  end
  
  def self.move_all(allegiance)
    Unit.select { |unit| unit.moving? && (unit.human? == allegiance)}.each { |unit| unit.move }
  end
  
  def destination
    move_path ? move_path.destination : self.location
  end
  
  # returns the name of the stat that this player is strongest with
  def strongest
    if red > blue && red > green
	  return :red
	elsif blue > red && blue > green
	  return :blue
	else
	  return :green
	end
  end
  
  def location
    node
  end
  
  def human?
    player.is_human
  end
  
  def move_path
    node_link
  end
end
