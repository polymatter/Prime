class AddStrengthToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :strength, :integer
  end
end
