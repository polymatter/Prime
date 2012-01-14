class Node < ActiveRecord::Base
  has_many :units
  belongs_to :node_type
  has_many :node_links #intermediate result for :linked_nodes
  has_many :linked_nodes, :through => :node_links #nodes traversable from this node
  
  after_initialize :init_instance_vars
  
  def init_instance_vars
    @default_strength = 25 # strength when allegiance changes
    @minimum_strength = 1
  end
  
  def colour
    node_type.name
  end
  
  def neighbours
    linked_nodes
  end
  
  def friendly_neighbours 
    neighbours.select {|node| node.human? == self.human?}
  end
  
  def enemy_neighbours 
    neighbours.select {|node| node.human? != self.human?}
  end
  
  def change_allegiance(allegiance = !human?)
    self.update_attributes({ :is_human => allegiance, :strength => @default_strength })
  end
  
  def enemy?(unit)
    # ^ is the Ruby XOR operator
    unit && (unit.human? ^ self.human?)
  end
  
  def friends?(unit)
    unit && (unit.human? == self.human?)
  end
  
  def attackers
    units.select{ |unit| self.enemy?(unit) }
  end
  
  def defenders
    units.select { |unit| self.friends?(unit) }
  end
  
  def human?
    is_human
  end
  
  def under_attack?
    !attackers.empty?
  end
  
  def take_damage(damage = 10)
    new_strength = [self.strength - damage, @minimum_strength].max
    self.update_attributes({ :strength => new_strength })
  end
end
