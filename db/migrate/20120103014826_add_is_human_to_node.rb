class AddIsHumanToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :is_human, :boolean
  end
end
