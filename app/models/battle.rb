# used as a namespace for all methods dealing with battles
module Battle
  @@win  = 'battle_win'
  @@fail = 'battle_fail'
  
  def self.resolve_move_and_battles
    # Move human units and computer units seperately to avoid units bypassing eachother
    Unit.select { |unit| unit.moving? && unit.human? }.each { |unit| unit.move }
	Node.select { |node| node.under_attack? }.each { |node| resolve_battle_at(node) }
  
    Unit.select { |unit| unit.moving? && !unit.human? }.each { |unit| unit.move }
	Node.select { |node| node.under_attack? }.each { |node| resolve_battle_at(node) }
  
    Unit.select { |unit| unit.moving? }.each { |unit| unit.stop }
  end
  
  # assumes node.under_attack? is true
  def self.resolve_battle_at(node)
    battle_colour = node.colour
    
    # attackers strength is the sum of all the strengths of the attacking units, in the appropriate colour
    attackers_strength = node.attackers.map {|unit| unit[battle_colour] }.inject(0,:+)
	
    # defenders strength is the max of node strength and the sum of defender strength
    sum_of_defender_units_strength = node.defenders.map {|unit| unit[battle_colour]}.inject(0,:+)
    defenders_strength = [sum_of_defender_units_strength, node.strength].max
   	
	msg = "#{node.name}, in a #{battle_colour} battle: ATT #{attackers_strength} to DEF #{defenders_strength}"
	# attackers win
	if attackers_strength > defenders_strength
	  winners = node.attackers ; losers = node.defenders
	  win_msg = ->(unit){"#{unit.name} conquer #{msg}"} ; fail_msg = ->(unit){"#{unit.name} lost #{msg}"}
	  node.take_damage
      node.change_allegiance
	# defenders win
	else
	  winners = node.defenders ; losers = node.attackers
	  win_msg = ->(unit){"#{unit.name} held #{msg}"} ; fail_msg = ->(unit){"#{unit.name} failed to capture #{msg}"}
	  node.take_damage
	end
	
	winners.each do |unit| 
	  unit.log(@@win, win_msg.call(unit))
      unit.stop
	end
	
	losers.each do |unit| 
	  unit.log(@@fail, fail_msg.call(unit))
	  unit.retreat
    end
	
  end
 
end