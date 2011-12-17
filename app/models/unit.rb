class Unit < ActiveRecord::Base
  belongs_to :node
  belongs_to :player
  belongs_to :node_link #represents the link a unit is traversing
  
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
