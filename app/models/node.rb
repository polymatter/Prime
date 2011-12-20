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
	unit_strength = 0
	
	if    node_type.name == "red"
	  unit_strength = unit.red
	elsif node_type.name == "blue"
	  unit_strength = unit.blue
	elsif node_type.name == "green"
	  unit_strength = unit.green
	else
	  unit_strength = 0
	end

	# if unit wins, node changes colour and its strength is restored	
	if strength > unit_strength 
      update_attributes ({:strength => strength - unit_strength })
	  unit.update_attributes ({:node_id => 1})
	  return "#{name} falls to attack from #{unit.name}"
	#if unit loses fight, respawn at starting node
    else   
	  update_attributes ({:node_type_id => 1, :strength => 99 })
	  return "#{name} repels attack from #{unit.name}"
    end  
  end
  
  def fight_computer(unit)
    unit_strength = unit[unit.strongest]
	
	if strength > unit_strength
	  update_attributes({:strength => strength - unit_strength })
	  return "#{name} repels attack from #{unit.name}"
	else
	  update_attributes({:node_type_id => 2, :strength => 10 })
	  return "#{name} fell to attack from #{unit.name}"
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
  
  def passable_to_humans
    return node_type.name == "white"
  end
  
  def passable_to_computers
    return node_type.name != "white"
  end
end
