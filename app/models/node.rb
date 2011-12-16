class Node < ActiveRecord::Base
  has_many :units
  belongs_to :node_type
  
  # define links to other nodes
  has_many :node_links
  has_many :linked_nodes, :through => :node_links
  
end
