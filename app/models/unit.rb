class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link a unit is traversing
  has_many :turn_logs
  
  def can_retreat
    node_link && !node_link.node.has_enemy_units(self)
  end
  
  def stationary
    self.update_attributes({ :node_link_id => 0})
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
  
  def log(code,msg)
    l = TurnLog.new
	l.update_attributes({ :notes => msg, :unit_id => self.id, :desc => code, :when => Time.now })
  end
  
  def move_with_undo
    self.update_attributes({:node_id => destination.id})
  end
  
  def move_message(node_id, verb)
    msg = "#{name} #{verb} #{Node.find(node_id).name}"
	log('move',msg)
    self.update_attributes({ :node_id => node_id})
	msg
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
  
  def battle_report(winner, loser, margin)
    win_msg = ''
	fail_msg = ''
	attacker = self # battle_report always called in attackers context
	
	if winner == attacker
	  win_msg = "#{winner.name} attacked and defeated #{loser.name}, by a margin of #{margin}"
	  fail_msg = "#{loser.name} was attacked and defeated by #{winner.name}, by a margin of #{margin}"
	else
	  win_msg = "#{loser.name} attacked, but was repelled by #{winner.name}, by a margin of #{margin}"
	  fail_msg = "#{winner.name} was attacked, but repelled #{loser.name}, by a margin of #{margin}"
	end
	
	winner.log('battle_win',win_msg)
    loser.log('battle_fail',fail_msg)
  end
  
  def attack(target_unit)
    # strongest = name of this units strongest stat (either :red, :blue or :green)
    margin = self[self.strongest] - target_unit[self.strongest]
    # if this unit attacks and wins
    if margin > 0
	  battle_report(self, target_unit, margin)
	  target_unit.retreat
	else
	  battle_report(target_unit, self, margin)
	  self.retreat
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
    node_link ? node_link.linked_node : node
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
