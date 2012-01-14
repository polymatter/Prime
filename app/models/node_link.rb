# node_id:integer linked_node_id:integer
class NodeLink < ActiveRecord::Base
  belongs_to :node
  belongs_to :linked_node, :class_name => "Node"
  has_many :units
  
  def origin
    node
  end
  
  def destination
    linked_node
  end
  
  def inverse
    inverses = NodeLink.keep_if { |link| link.node == linked_node && link.linked_node == node }
	inverses.first if inverses
  end
  
end
