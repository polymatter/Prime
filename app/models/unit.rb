class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link a unit is traversing
  
  def human_fight_node(node)
    stat = node.node_type.name
	unit_strength = 0
	
	if stat == "red"
	  unit_strength = red
	elsif stat == "blue"
	  unit_strength = blue
	elsif stat == "green"
	  unit_strength = green
	else
	  unit_strength = 0
	end
	
	#if unit loses fight, respawn at starting node
	if node.strength > unit_strength 
      node.update_attributes ({:strength => node.strength - unit_strength })
	  update_attributes ({:node_id => 1})
	# if unit wins, node changes colour and its strength is restored
    else   
	  node.update_attributes ({:node_type_id => 1, :strength => 99 })
    end
  end
  
  # a unit is moving if there is a valid node_link. 
  # note that a stationary unit is modelled as one with a node_link_id of 0
  def moving?
    node_link
  end
  
  def move
    if moving?
	  update_attributes ({:node_id => destination.id, :node_link_id => 0 })
	end
  end
  
  def destination
    if moving?
	  return node_link.linked_node
	else
	  return nil
	end
  end
  
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
