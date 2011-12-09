class Node < ActiveRecord::Base
  has_many :units
  
  # define valid links
  has_many :node_links
  has_many :linked_nodes, :through => :node_links
  
end