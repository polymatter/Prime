# node_id:integer linked_node_id:integer
class NodeLink < ActiveRecord::Base
  belongs_to :node
  belongs_to :linked_node, :class_name => "Node"
  has_many :units
end
