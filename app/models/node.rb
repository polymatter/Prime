class Node < ActiveRecord::Base
  has_many :units
  belongs_to :node_type
  
  # define links to other nodes
  has_many :node_links
  has_many :linked_nodes, :through => :node_links

  def fight_computer(unit)
    unit_strength = unit[unit.strongest]
	
	if strength > unit_strength
	  update_attributes({:strength => strength - unit_strength })
	  name + " defences held attack from " + unit.name
	else
	  update_attributes({:node_type_id => 2, :strength => 10 })
	  name + " fell to attack from " + unit.name
	end
	
  end
  
  def human_units
     units.collect {|unit| unit if unit.player.is_human? }.delete_if {|e| e == nil }
  end
  
  def computer_units
    units.collect {|unit| unit if unit.player.is_computer? }.delete_if {|e| e == nil }
  end
  
  def passable_to_humans?
    return node_type.name == "white"
  end
  
  def passable_to_computers?
    return node_type.name != "white"
  end
end
