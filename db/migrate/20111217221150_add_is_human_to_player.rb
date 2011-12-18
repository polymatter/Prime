class AddIsHumanToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :is_human, :boolean
	Player.all.each {|player| player.update_attributes({:is_human => 'false'})}
  end
end
