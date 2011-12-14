class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
end
