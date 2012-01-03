class Node < ActiveRecord::Base
  has_many :units
  belongs_to :node_type
  
  # define links to other nodes
  has_many :node_links
  has_many :linked_nodes, :through => :node_links

  def is_enemy(unit)
    # when unit is nil, return false to avoid fighting an absent unit
    # ^ is the Ruby XOR operator
    unit && (unit.player.is_human ^ passable_to_humans)
	# means the same as:
	# unit && ((unit.player.is_human || passable_to_humans) && !(unit.player.is_human && passable_to_humans))
  end
  
  def has_enemy_units(unit)
    unit.player.is_human ? has_computer_units : has_human_units
  end
  
  def enemy_units
    passable_to_humans ? computer_units : human_units
  end
  
  def fight_unit(unit)
    unit.player.is_human ? fight_human(unit) : fight_computer(unit)
  end
  
  def fight_human(unit)
    # human units must use the attack type that the node uses
    unit_strength = unit[node_type.name]
	margin = unit_strength - self.strength
	
	# if unit wins, node changes alligance and its strength is restored	
	if margin > 0
	  msg = "#{name} falls to invasion from #{unit.name}, by a margin of #{margin}"
	  unit.log('player_invade_win',msg)
	  self.update_attributes ({:is_human => true, :strength => 99 })
	#if unit loses fight, respawn at starting node
    else   
	  msg = "#{name} repels invasion from #{unit.name}, by a margin of #{margin}"
	  unit.log('player_invade_fail',msg)
	  unit.move_message(1, 'respawns at')
	  self.update_attributes ({:strength => strength - unit_strength })
    end  
  end
  
  def fight_computer(unit)
    # computer unit always fights with their strongest attack
    unit_strength = unit[unit.strongest]
	margin = unit_strength - self.strength 
	
	if margin < 0
	  msg = "#{name} repels attack from #{unit.name}, by a margin of #{margin}"
	  unit.log('computer_invade_fail',msg)
	  update_attributes({:strength => strength - unit_strength })
	  # computer unit does not respawn when invasion fails
	else
	  msg = "#{name} fell to attack from #{unit.name}, by a margin of #{margin}"
	  unit.log('computer_invade_win',msg)
	  update_attributes({:is_human => false, :strength => 99 })
	end
	
  end
  
  def has_friendly_units
    passable_to_humans ? has_human_units : has_computer_units
  end
  
  def has_human_units
    !human_units.empty?
  end
  
  def has_no_human_units
    human_units.empty?
  end
  
  def human_units
     units.select {|unit| unit.player.is_human }
  end
  
  def has_computer_units
    !computer_units.empty?
  end
  
  def has_no_computer_units
    computer_units.empty?
  end
  
  def computer_units
    units.select {|unit| !unit.player.is_human }
  end
  
  def passable_to_humans?
    passable_to_humans
  end
  
  def passable_to_humans
    is_human
  end
  
  def passable_to_computers?
    passable_to_computers
  end
  
  def passable_to_computers
    !is_human
  end
end
