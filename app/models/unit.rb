class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link a unit is traversing
end
