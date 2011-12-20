class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link a unit is traversing
  
  def can_retreat
    node_link && !node_link.node.has_enemy_units(self)
  end
  
  def retreat
    human_teleport_to_node_id = 1
	computer_teleport_to_node_id = 5
  
    if can_retreat
	  move_message(node_link.node.id, "retreated to")
	else
	  if player.is_human
	    move_message(human_teleport_to_node_id, "respawned at")
	  else
	    move_message(computer_teleport_to_node_id, "respawned at")
	  end
    end
  end
  
  def move_message(node_id, verb)
    self.update_attributes({ :node_id => node_id})
	"#{name} #{verb} #{Node.find(node_id).name}\n"
  end
  
  def is_enemy(unit)
    # ^ is the XOR operator
    player.is_human ^ unit.player.is_human
	# same thing as
	# (player.is_human || unit.player.is_human) && !(player.is_human && unit.player.is_human)
  end
  
  def in_enemy_territory
    node && node.is_enemy(self)
  end
  
  def battle_report(winner, loser)
    if winner == self
	  "#{name} attacked and defeated #{loser.name}\n"
	else
	  "#{name} attacked, but was defeated by #{winner.name}\n"
	end
  end
  
  def attack(target_unit)
    # if this unit attacks and wins
    if self[self.strongest] > target_unit[self.strongest]
	  { :result => :win, :message => battle_report(self, target_unit) + target_unit.retreat }
	else
	  { :result => :lose, :message => battle_report(target_unit, self) + self.retreat }
	end
  end
  
  # a unit is moving if there is a valid node_link. 
  # note that a stationary unit is modelled as one with a node_link_id of 0
  def moving?
    node_link
  end
  
  def move
    if moving?
	  undo = {:node_id => node_id}
	  update_attributes ({:node_id => destination.id, :node_link_id => 0 })
	  return undo
	end
  end
  
  def destination
    if moving?
	  return node_link.linked_node
	else
	  return node
	end
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
end
