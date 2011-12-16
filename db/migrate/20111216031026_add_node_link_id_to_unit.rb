class AddNodeLinkIdToUnit < ActiveRecord::Migration
  #create faux model so that any changes are not immediately propagated until migrations have finished
  #this is totally unnecessary at the moment since I am the only developer, but I am doing this to get
  #into good habits and thinking about the cases where other developers may be making migrations at the
  #same time as me. I am following guidelines detailed at 
  # http://guides.rubyonrails.org/migrations.html#using-models-in-your-migrations
  class Unit < ActiveRecord::Base
  end

  def change
    add_column :units, :node_link_id, :integer
	#refreshes the ActiveRecord cache for Unit model prior to updating data
	Unit.reset_column_information
	#make any previously created units, default to a node_link_id of 0
	Unit.all.each {|unit| unit.update_attributes!(:node_link_id => 0) }
  end
end
