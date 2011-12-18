class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link a unit is traversing
  
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
